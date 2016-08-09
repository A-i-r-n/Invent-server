json.code (@payment ? 0 : 1)
json.data do
    json.partial! 'jshare/payment', payment: @payment
end