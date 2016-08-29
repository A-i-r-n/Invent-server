json.code (@address ? 0 : 1)
json.data do
  json.partial! 'jshare/address',address: @address
end