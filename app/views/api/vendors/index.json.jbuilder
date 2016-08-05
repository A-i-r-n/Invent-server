json.code (@vendors ? 0 : 1)
json.data do
  json.list(@vendors) do |vendor|
    json.partial! 'jshare/vendor', vendor: vendor
      json.set! 'category' do
        json.partial! 'jshare/category',category: vendor.product_category
      end
  end
  json.partial! 'jshare/page',model: @vendors
end