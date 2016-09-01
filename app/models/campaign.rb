class Campaign < ActiveRecord::Base

  has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Attachment'

  has_many :campaign_orders

  def attachments=(attrs)
    attachments.build(attrs['image']) if attrs['image']['file'].present?
  end

  def default_image
    attachments.order(created_at: :desc).for('default_image')
  end

  def default_image_file=(file)
    attachments.build(file: file, role: 'default_image')
  end

end
