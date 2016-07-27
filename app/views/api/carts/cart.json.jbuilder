json.code (@cart ? 0 : 1)
json.data do
    json.extract! @cart,:id,:num,:product_id
end