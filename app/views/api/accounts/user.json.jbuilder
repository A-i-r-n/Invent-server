json.code (@user ? 0 : 1)
json.data do
  json.extract! @user, :id,:name,:phone,:created_at, :updated_at
end