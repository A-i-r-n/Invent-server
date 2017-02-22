json.code (@bags ? 0 : 1)
json.data do
  json.list(@bags) do |bag|
    json.extract! bag,:id,:name,:price,:explain,:color

    attachment = bag.attachment
    if attachment.present? && attachment.image?
      json.image_url image_url(attachment.file.url)
    end
  end
end