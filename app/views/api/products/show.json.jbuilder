json.code (@product ? 0 : 1)
json.data do
  json.extract! @product, :id,:name,:created_at, :updated_at
end