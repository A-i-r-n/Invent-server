json.code @product_attributes ? 0 : 1
json.data do
  json.list(@product_attributes) do |group,attributes|
    json.name group
    json.list(attributes) do |attribute|
      json.extract! attribute,:id,:key,:value,:position
    end
  end
end