json.code (@share ? 0 : 1)
json.data do
  json.extract! @share,:id
end