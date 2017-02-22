json.code (@musics ? 0 : 1)
json.data do
  json.list(@musics) do |music|
    json.extract! music,:id,:name,:explain

    attachment = music.attachment
    if attachment.present? && attachment.image?
      json.image_url image_url(attachment.file.url)
    end
  end
end