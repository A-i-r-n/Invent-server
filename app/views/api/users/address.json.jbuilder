json.code (@address ? 0 : 1)
json.data do
  json.extract! @address , :id,:full_name,:created_at, :updated_at
end