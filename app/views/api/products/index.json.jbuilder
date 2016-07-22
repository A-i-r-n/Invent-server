json.code 0 if @products
json.data do
  json.list(@products) do |product|
    json.partial! 'jshare/product', product: product
  end
  json.page params[:page]
end