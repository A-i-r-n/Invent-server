json.code (@attachments ? 0 : 1)
json.data do
  json.list(@attachments) do |attachment|
    json.partial! 'jshare/attachment',attachment: attachment
  end
end