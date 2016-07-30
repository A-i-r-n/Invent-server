json.code (@banners ? 0 : 1)
json.data do
  json.list(@banners) do |banner|
    json.extract! banner,:id,:name,:link

    attachment = banner.attachment
    if attachment.present? && attachment.image?
      json.image_url image_url(attachment.file.url)
    end
  end
end