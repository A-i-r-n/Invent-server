json.code @products ? 0 : 1
json.data do
  json.list(@products) do |product|
    json.partial! 'jshare/product', product: product
  end
end