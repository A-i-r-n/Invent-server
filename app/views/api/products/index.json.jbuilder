json.code 0 if @products.count>0
json.data do
  json.list(@products) do |product|
    json.extract! product, :id,:name,:created_at, :updated_at
  end
  json.page params[:page]
end