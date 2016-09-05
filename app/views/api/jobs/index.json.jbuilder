json.code (@jobs ? 0 : 1)
json.data do
  json.list(@jobs) do |job|
    json.partial! 'jshare/campaign',campaign: job
  end
  json.partial! 'jshare/page',model: @jobs
end