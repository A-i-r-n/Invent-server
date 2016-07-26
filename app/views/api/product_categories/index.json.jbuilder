json.code (@product_categories ? 0 : 1)
json.data do
  json.list(@product_categories) do |category|
    json.extract! category, :id,:name,:created_at, :updated_at
    attachment = category.attachments.find_all{ |a| a.role == 'default_image'  }.first
    if attachment then json.image_url image_url(attachment.file.url)  end
  end
  json.page params[:page]
end