json.code @products ? 0 : 1
json.data do
  json.list(@products) do |product|
    json.partial! 'jshare/product', product: product
    json.attributes(product.product_attributes) do |attribute|
      json.extract! attribute,:id,:key,:value,:position
    end
  end
end