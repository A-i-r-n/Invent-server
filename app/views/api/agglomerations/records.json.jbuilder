json.code (@agglomeration_records ? 0 : 1)
json.data do
  json.list(@agglomeration_records) do |agglomeration_record|
    json.partial! 'jshare/campaign_record',campaign_record: agglomeration_record
  end
end