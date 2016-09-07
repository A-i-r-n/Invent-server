json.extract! unboxing,:id,:description,:created_at
if unboxing.campaign_record
  json.set! 'campaign_record' do
    json.partial! 'jshare/campaign_record',campaign_record: unboxing.campaign_record
  end
end