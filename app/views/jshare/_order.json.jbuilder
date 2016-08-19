json.set! :order_items_attributes do
  json.array!(order.order_items) do |item|
    json.extract! item,:ordered_item_type,:ordered_item_id,:quantity,:unit_price,:tax_amount,:weight,:carriage_price
    # json.product_id item.ordered_item.id
    # json.product_name item.ordered_item.name
    # json.product_image_url item.ordered_item.image_url
    json.set! 'product' do
      json.partial! 'jshare/product', product: item.ordered_item
    end

  end
end
json.extract! order,:id,:carriage_price,:total,:status

if order.coupon
  json.set! 'coupon' do
    json.partial! 'jshare/coupon',coupon: order.coupon
  end
end

if  order.vendor
  json.set! 'vendor' do
    json.partial! 'jshare/vendor',vendor: order.vendor
  end
end