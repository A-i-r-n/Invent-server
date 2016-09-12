json.code (@messages ? 0 : 1)
json.data do
  json.list(@messages) do |message|
    json.extract! message,:id,:phone,:content,:message_type,:created_at
  end
json.partial! 'jshare/page',model: @messages
end