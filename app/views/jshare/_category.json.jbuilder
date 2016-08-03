json.extract! category, :id,:name,:created_at, :updated_at
attachment = category.attachments.find_all{ |a| a.role == 'default_image'  }.first
if attachment then json.image_url image_url(attachment.file.url)  end