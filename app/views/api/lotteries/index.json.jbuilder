json.code (@lotteries ? 0 : 1)
json.data do
  json.list(@lotteries) do |lottery|
    json.partial! 'jshare/lottery',lottery: lottery
  end
end