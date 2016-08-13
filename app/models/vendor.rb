class Vendor < ActiveRecord::Base

  define_model_callbacks :acceptance
  STATUSES = %w(confirming received accepted rejected).freeze

  belongs_to :user

  # Attachments for this product
  has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Attachment'

  belongs_to :product_category

  belongs_to :province ,class_name: "Area",foreign_key: :pid
  belongs_to :city ,class_name: "Area",foreign_key: :cid
  belongs_to :street ,class_name: "Area",foreign_key: :sid

  scope :received,->{
    where(status: 'received')
  }

  def self.with_distance(location)
    columns = [:id,:name,:grade_num,:grade_score,:latitude,:longitude,:user_id,:product_category_id,:pid,:cid,:sid,:sold_num,:address,:created_at,:updated_at]
    location.empty? ? self : select(columns ," #{mysql_distance(location[:lat],location[:lng])} as distance ")
  end

  def self.mysql_distance(lat,long)
    %" ROUND(6378.138*2*ASIN(SQRT(POW(SIN((#{lat}*PI()/180-latitude*PI()/180)/2),2)
          +COS(#{lat}*PI()/180)*COS(latitude*PI()/180)*POW(SIN((#{long}*PI()/180-longitude*PI()/180)/2),2)))*1000) "
  end

  def distance
    read_attribute(:distance) || BigDecimal(0)
  end

  def location
    "#{province && province.name} #{city && city.name} #{street && street.name}".gsub(/^\s|\s$/,"")
  end


  def self.order_by(location,order_by_distance)
    (location.empty? && ! order_by_distance) ? order(:created_at) : order(" distance asc ")
  end

  def self.keywords_ransack(keywords)
    if keywords.blank?
      self
    else
      ransack(keywords_cont_all: keywords.split)
          .result
    end
  end

  def attachments=(attrs)
    attachments.build(attrs['image']) if attrs['image']['file'].present?
  end

  def rejected?
    status == 'rejected'
  end

  # Has this order been accepted?
  #
  # @return [Boolean]
  def accepted?
    status == 'accepted'
  end

  def licence_image
    attachments.order(created_at: :desc).for('licence_image')
  end

  def default_image
    attachments.order(created_at: :desc).for('default_image')
  end

  # Mark order as accepted
  #
  # @param user [Shoppe::User] the user who carried out this action
  def accept#!(user = nil)
    run_callbacks :acceptance do
      # self.accepted_at = Time.now
      # self.accepter = user if user
      self.status = 'accepted'
      self.user.accept_vendor
      # order_items.each(&:accept!)
      # deliver_accepted_order_email
    end
  end

  # Mark order as rejected
  #
  # @param user [Shoppe::User] the user who carried out the action
  def reject#!(user = nil)
    run_callbacks :rejection do
      # self.rejected_at = Time.now
      # self.rejecter = user if user
      self.status = 'rejected'
      save!
      # order_items.each(&:reject!)
      # deliver_rejected_order_email
    end
  end

end