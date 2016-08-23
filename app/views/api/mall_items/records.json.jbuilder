json.code (@mall_item_records ? 0 : 1)
json.data do
  json.list(@mall_item_records) do |mall_item_record|
    json.partial! 'jshare/campaign_record',campaign_record: mall_item_record
  end
end