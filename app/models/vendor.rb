class Vendor < ActiveRecord::Base

  STATUSES = %w(received accepted rejected).freeze

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
    columns = [:id,:name,:grade_num,:grade_score,:latitude,:longitude,:user_id,:product_category_id,:pid,:cid,:sid,:sold_num,:created_at,:updated_at]
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

end