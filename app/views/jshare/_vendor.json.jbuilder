json.extract! vendor, :id,:name,:created_at, :updated_at
attachment = vendor.attachments.for('licence_image')
if attachment then json.image_url image_url(attachment.file.url) end