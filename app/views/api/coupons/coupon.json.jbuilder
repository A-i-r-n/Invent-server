json.code (@coupon ? 0 : 1)
json.data do
    json.partial! 'jshare/coupon',coupon: @coupon
end