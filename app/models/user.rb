class User < ActiveRecord::Base
  # self.table_name = 'shoppe_users'

  # has_secure_password

  include ConfigManager

  belongs_to :profile
  belongs_to :text_filter
  has_one :resource , as: :file, dependent: :destroy

  delegate :name, to: :text_filter, prefix: true
  delegate :label, to: :profile, prefix: true

  # has_many :notifications, foreign_key: 'notify_user_id'
  # has_many :notify_contents, -> { uniq }, through: :notifications,
  #          source: 'notify_content'
  #
  # has_many :articles

  has_many :user_profiles, dependent: :restrict_with_exception, class_name: 'UserProfile', inverse_of: :user
  has_many :profiles, class_name: 'Profile', through: :user_profiles


  has_one :vendor

  has_one :customer

  has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Attachment'

  has_many :user_coupons, dependent: :restrict_with_exception, class_name: 'UserCoupon', inverse_of: :user
  has_many :coupons, class_name: 'Coupon', through: :user_coupons

  serialize :settings, Hash

  STATUS = %w(active inactive)

  attr_accessor :filename

  # Settings
  setting :notify_watch_my_articles, :boolean, true
  setting :firstname, :string, ''
  setting :lastname, :string, ''
  setting :nickname, :string, ''
  setting :description, :string, ''
  setting :url, :string, ''
  setting :msn, :string, ''
  setting :aim, :string, ''
  setting :yahoo, :string, ''
  setting :twitter, :string, ''
  setting :jabber, :string, ''
  setting :admin_theme, :string, 'blue'
  setting :twitter_account, :string, ''
  setting :twitter_oauth_token, :string, ''
  setting :twitter_oauth_token_secret, :string, ''
  setting :twitter_profile_image, :string, ''

  scope :admin , -> {
    role(:admin)
  }

  scope :vendor,->{
    role(:vendor)
  }

  scope :customer,->{
    role(:customer)
  }

  scope :role,->(role){
    joins(:profiles).where(" profiles.label = ? ",role)
  }


  # echo "publify" | sha1sum -
  class_attribute :salt

  def self.salt
    '20ac4d290c2293702c64b3b287ae5ea79b26a5c1'
  end

  attr_accessor :last_venue

  def accept_vendor
    self.profiles << Profile.find_by_label(:vendor)
    save
  end

  def take_coupon(coupon)
    if ! coupons.include?(coupon)
      coupons << coupon
      save
    end
  end


  def first_and_last_name
    return '' unless firstname.present? && lastname.present?
    "#{firstname} #{lastname}"
  end

  def display_names
    [:login, :nickname, :firstname, :lastname, :first_and_last_name].map { |f| send(f) }.delete_if(&:empty?)
  end

  def self.authenticate(login, pass)
    find_by('login = ? AND password = ?', login, password_hash(pass))# AND state = ? , 'active'
  end

  def update_connection_time
    self.last_venue = last_connection
    self.last_connection = Time.now
    save
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 7.days
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token_last = self.remember_token
    self.remember_token = Digest::SHA1.hexdigest("#{self.login}--#{self.remember_token_expires_at}")
    save(validate: false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token = nil
    save(validate: false)
  end

  def default_text_filter
    text_filter
  end

  def self.authenticate?(login, pass)
    user = authenticate(login, pass)
    return false if user.nil?
    return true if user.login == login

    false
  end

  def self.find_by_permalink(permalink)
    find_by_login(permalink).tap do |user|
      raise ActiveRecord::RecordNotFound unless user
    end
  end

  delegate :project_modules, to: :profile

  # AccessControl.available_modules.each do |m|
  #   define_method("can_access_to_#{m}?") { can_access_to?(m) }
  # end

  # def can_access_to?(m)
  #   profile.modules.include?(m)
  # end

  # Generate Methods takes from AccessControl rules
  # Example:
  #
  #   def publisher?
  #     profile.label == :publisher
  #   end


  # AccessControl.roles.each do |role|
  #   define_method "#{role.to_s.downcase}?" do
  #     profile.label.to_s.downcase == role.to_s.downcase
  #   end
  # end

  def attachments=(attrs)
    attachments.build(attrs['image']) if attrs['image']['file'].present?
  end

  def avatar
    attachments.order(created_at: :desc).for('avatar_image')
  end

  def self.to_prefix
    'author'
  end

  attr_writer :password

  attr_writer :verify_password

  def password(cleartext = nil)
    if cleartext
      @password.to_s
    else
      @password || self[:password]
    end
  end

  def verify_password(cleartext = nil)
    if cleartext
      @verify_password.to_s
    else
      @verify_password || self[:verify_password]
    end
  end

  def article_counter
    articles.size
  end

  def display_name
    if !nickname.blank?
      nickname
    elsif !name.blank?
      name
    else
      login
    end
  end

  def permalink
    login
  end

  def admin?
    profile.label == Profile::ADMIN
  end

  def update_twitter_profile_image(img)
    return if twitter_profile_image == img
    self.twitter_profile_image = img
    save
  end

  def generate_password!
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    newpass = ''
    1.upto(7) { |_i| newpass << chars[rand(chars.size - 1)] }
    self.password = newpass
  end

  def has_twitter_configured?
    twitter_oauth_token.present? && twitter_oauth_token_secret.present?
  end

  def add_score(score)
    self.score += score
    return if self.score > CreditRating::HIGHTEST
    self.level = CreditRating.find_by(%" low_scores <= :score and high_scores >= :score ",
                                      :score => self.score).level
    save
  end

  def update_location(lat,long)
    self.latitude = lat
    self.longitude = long
    save
  end

  def update_password(pass)
    @password = pass
    save
  end

  def update_verify_password(pass)
    @verify_password = pass
    save
  end


  def self.password_hash(pass)
    Digest::SHA1.hexdigest("#{salt}--#{pass}--")
  end

  protected

  # Apply SHA1 encryption to the supplied password.
  # We will additionally surround the password with a salt
  # for additional security.

  def password_hash(pass)
    self.class.password_hash(pass)
  end

  before_create :crypt_password

  before_create :crypt_verify_password

  # Before saving the record to database we will crypt the password
  # using SHA1.
  # We never store the actual password in the DB.
  # But before the encryption, we send an email to user for he can remind his
  # password
  def crypt_password
    # EmailNotify.send_user_create_notification self
    self[:password] =
        password_hash(password(true))
    @password = nil
  end

  def crypt_verify_password
    if verify_password(true).empty?
      self[:verify_password] =  self[:password]
    else
      self[:verify_password] = password_hash(verify_password(true))
      @verify_password = nil
    end
  end

  before_update :crypt_unless_empty
  # If the record is updated we will check if the password is empty.
  # If its empty we assume that the user didn't want to change his
  # password and just reset it to the old value.
  def crypt_unless_empty
    if password(true).empty?
      user = self.class.find(id)
      self[:password] = user.password
    else
      crypt_password
    end

    if verify_password(true).empty?
      user = self.class.find(id)
      self[:verify_password] = user.verify_password
    else
      crypt_verify_password
    end

  end

  before_validation :set_default_profile

  def set_default_profile
    self.profiles <<  Profile.find_by_label(User.count.zero? ? 'admin' : 'customer')
  end

  # validates :login,presence: {  message: 'is forgotten.' }, uniqueness: true, on: :create #if: :login_required?,
  # validates :email ,presence: {  message: 'is forgotten.' },uniqueness: true, on: :create
  validates :password, length: {in: 5..40,message:"请输入5位以上的密码长度"}, if: proc { |user|
    user.read_attribute('password').nil? or user.password.to_s.length > 0
  }

  # validates :email, :login, presence: false

  validates_presence_of :login,:message => "用户名不能为空"

  validates_uniqueness_of :login,:case_sensitive => false,:message => "此用户名已被注册"

  validates :password, confirmation: true
  validates :login, length: {in: 3...40,message: "请输入3位以上的用户名"}
end
