class Vendor < ActiveRecord::Base
  belongs_to :user

  # Attachments for this product
  has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Attachment'

  belongs_to :product_category


  def attachments=(attrs)
    attachments.build(attrs['image']) if attrs['image']['file'].present?
  end

end
