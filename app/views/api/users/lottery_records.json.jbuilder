json.code (@lottery_records ? 0 : 1)
json.data do
  json.list(@lottery_records) do |lottery_record|
    json.partial! 'jshare/campaign_record',campaign_record: lottery_record
  end
json.partial! 'jshare/page',model: @lottery_records
end