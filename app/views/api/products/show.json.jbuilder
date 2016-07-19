json.code (@product ? 0 : 1)
json.data do
  json.partial! 'jshare/product', product: @product
end