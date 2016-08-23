json.extract! attachment, :id,:file_name,:created_at, :updated_at
json.image_url image_url(attachment.file.url)