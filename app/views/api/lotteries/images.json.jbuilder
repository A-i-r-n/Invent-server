json.code (@attachments ? 0 : 1)
json.data do
  json.list(@attachments) do |attachment|
    json.extract! attachment, :id,:file_name,:created_at, :updated_at
    json.image_url image_url(attachment.file.url)
  end

end