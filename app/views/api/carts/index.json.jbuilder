json.code (@carts ? 0 : 1)
json.data do
  json.list(@carts) do |vendor,carts|
    json.extract! vendor ,:id,:name
    json.carts(carts) do |cart|
      json.extract! cart,:id,:num
      json.set! 'product' do
        json.partial! 'jshare/product', product: cart.product
      end
    end
  end
end