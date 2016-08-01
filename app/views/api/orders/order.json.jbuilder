json.code (@orders ? 0 : 1)
json.data do
  json.list(@orders) do |order|
    json.partial! 'jshare/order', order: order
  end
end