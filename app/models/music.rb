class Music < ActiveRecord::Base

  has_one :attachment, as: :parent, dependent: :destroy, class_name: 'Attachment'

  def attachments=(attrs)
    self.attachment = Attachment.new(attrs['image']) if attrs['image']['file'].present?
    # attachment.build(attrs['image']) if attrs['image']['file'].present?
  end

  def default_image
    attachment
    # attachments.order(created_at: :desc).for('default_image')
  end

  def default_image_file=(file)
    self.attachment = Attachment.new(file: file, role: 'default_image')
    # attachments.build(file: file, role: 'default_image')
  end

end
