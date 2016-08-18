json.code (@coupons ? 0 : 1)
json.data do
  json.list(@coupons) do |coupon|
    json.partial! 'jshare/coupon',coupon: coupon
    if coupon.vendor
      json.set! 'vendor' do
        json.partial! 'jshare/vendor',vendor: coupon.vendor
      end
    end
  end
  json.partial! 'jshare/page',model: @coupons
end