json.code (@product_categories ? 0 : 1)
json.data do
  json.list(@product_categories) do |category|
    json.extract! category, :id,:name,:created_at, :updated_at
  end
  json.page params[:page]
end