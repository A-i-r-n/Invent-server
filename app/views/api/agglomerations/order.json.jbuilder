json.code (@agglomeration_order ? 0 : 1)
json.data do
  json.partial! 'jshare/campaign_order',campaign_order: @agglomeration_order
end