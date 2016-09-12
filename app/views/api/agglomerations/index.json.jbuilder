json.code (@agglomerations ? 0 : 1)
json.data do
  json.list(@agglomerations) do |agglomeration|
    json.partial! 'jshare/campaign',campaign: agglomeration
    # json.end_time agglomeration.end_time.to_datetime.strftime('%Q')
  end
end