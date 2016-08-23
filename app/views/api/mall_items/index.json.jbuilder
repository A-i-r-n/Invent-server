json.code (@mall_items ? 0 : 1)
json.data do
  json.list(@mall_items) do |mall_item|
    json.partial! 'jshare/campaign',campaign: mall_item
  end
end