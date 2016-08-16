json.code (@lottery ? 0 : 1)
json.data do
  json.partial! 'jshare/lottery',lottery: @lottery
end