json.code (@lottery ? 0 : 1)
json.data do
  json.partial! 'jshare/campaign',campaign: @lottery
end