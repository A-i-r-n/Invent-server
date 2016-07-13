json.code (@addresses ? 0 : 1)
json.data do
  json.list(@addresses) do |address|
    json.extract! address , :id,:full_name,:created_at, :updated_at
  end
  json.page params[:page]
end