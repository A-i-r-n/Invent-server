json.code (@addresses ? 0 : 1)
json.data do
  json.list(@addresses) do |address|
    json.partial! 'jshare/address',address: address
  end
  json.page params[:page]
end