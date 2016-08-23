json.code (@lottery_order ? 0 : 1)
json.data do
  json.partial! 'jshare/campaign_order',campaign_order: @lottery_order
end