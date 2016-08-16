json.code (@lottery_order ? 0 : 1)
json.data do
    json.extract! @lottery_order,:id,:code,:periods
end