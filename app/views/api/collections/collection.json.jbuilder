json.code (@collection ? 0 : 1)
json.data do
  json.extract! @collection,:id,:num,:product_id

  case @collection.parent
    when Product
      json.set! 'product' do
        json.partial! 'jshare/product', product: @collection.parent
      end
    when Vendor
      json.set! 'vendor' do
        json.partial! 'jshare/vendor', vendor: @collection.parent
      end
  end
end