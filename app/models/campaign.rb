class Campaign < ActiveRecord::Base

  has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Attachment'

  has_many :campaign_orders

  def attachments=(attrs)
    if attrs['image'] && attrs['image']['file'].present? then attachments.build(attrs['image'])  end
    if attrs['default_image'] && attrs['default_image']['file'].present? then attachments.build(attrs['default_image']) end
    if attrs['data_sheet'] && attrs['data_sheet']['file'].present? then attachments.build(attrs['data_sheet']) end
    if attrs['extra'] && attrs['extra']['file'].present? then attrs['extra']['file'].each { |attr| attachments.build(file: attr, parent_id: attrs['extra']['parent_id'], parent_type: attrs['extra']['parent_type']) } end
  end

  def data_sheet
    attachments.for('data_sheet')
  end

  def default_image
    attachments.order(created_at: :desc).for('default_image')
  end

  def default_image_file=(file)
    attachments.build(file: file, role: 'default_image')
  end

end
