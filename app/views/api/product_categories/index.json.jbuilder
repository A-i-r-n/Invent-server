json.code (@product_categories ? 0 : 1)
json.data do
  json.list(@product_categories) do |category|
    json.partial! 'jshare/category',category: category
  end
  json.page params[:page]
end