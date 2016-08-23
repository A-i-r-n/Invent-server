json.extract! campaign_record, :id,:code,:periods,:created_at, :updated_at

if campaign_record.user
  json.set! 'user' do
    json.partial! 'jshare/user',user: campaign_record.user
  end
end

if campaign_record.campaign
  json.set! 'lottery' do
    json.partial! 'jshare/campaign',campaign: campaign_record.campaign
  end
end