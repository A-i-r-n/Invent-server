json.code (@shoes ? 0 : 1)
json.data do
  json.list(@shoes) do |shoe|
    json.extract! shoe,:id,:name,:price,:color,:height

    attachment = shoe.attachment
    if attachment.present? && attachment.image?
      json.image_url image_url(attachment.file.url)
    end
  end
end