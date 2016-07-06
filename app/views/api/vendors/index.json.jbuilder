json.code (@vendors ? 0 : 1)
json.data do
  json.list(@vendors) do |vendor|
    json.extract! vendor, :id,:name,:created_at, :updated_at
  end
  json.page params[:page]
end