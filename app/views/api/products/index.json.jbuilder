json.code 0 if @products.count>0
json.data(@products) do |category, products|
  json.array!(products) do |product|
    json.extract! product, :id,:name,:created_at, :updated_at
    json.category do
      json.extract! category, :id,:name
    end
  end
end