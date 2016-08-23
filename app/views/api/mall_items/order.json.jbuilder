json.code (@mall_item_order ? 0 : 1)
json.data do
  json.partial! 'jshare/campaign_order',campaign_order: @mall_item_order
  json.extract! @mall_item_order,:jluck
end