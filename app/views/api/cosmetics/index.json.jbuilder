json.code (@cosmetic ? 0 : 1)
json.data do
  json.list(@cosmetics) do |cosmetic|
    json.extract! cosmetic,:id,:name,:price,:explain

    attachment = cosmetic.attachment
    if attachment.present? && attachment.image?
      json.image_url image_url(attachment.file.url)
    end
  end
end