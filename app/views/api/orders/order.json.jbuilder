json.code (@order ? 0 : 1)
json.data do
  json.set! :order_items_attributes do
    json.array!(@order.order_items) do |item|
      json.extract! item,:ordered_item_type,:ordered_item_id
    end
  end
  json.carriage_price @order.carriage_price
end