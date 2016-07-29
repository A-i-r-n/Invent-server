json.code (@order ? 0 : 1)
json.data do
  json.partial! 'jshare/order', order: @order
end