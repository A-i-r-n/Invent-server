json.code (@vendors ? 0 : 1)
json.data do
  json.list(@vendors) do |vendor|
    json.extract! vendor, :id,:name,:created_at, :updated_at
    attachment = vendor.attachments.find_all{ |a| a.role == 'default_image' }.first
    if attachment then json.image_url image_url(attachment.file.url) end
  end
  json.page params[:page]
end