json.code (@payments ? 0 : 1)
json.data do
  json.list(@payments) do |payment|
    json.partial! 'jshare/payment', payment: payment
  end
end