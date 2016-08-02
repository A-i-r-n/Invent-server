json.extract! vendor, :id,:name,:created_at, :updated_at
licence_attachment = vendor.attachments.for('licence_image')
if licence_attachment then json.licence_image_url image_url(licence_attachment.file.url) end

default_attachment = vendor.attachments.for('default_image')
if default_attachment then json.image_url image_url(default_attachment.file.url) end