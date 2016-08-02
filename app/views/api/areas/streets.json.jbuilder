json.code (@area ? 0 : 1)
json.data do
  json.list(@area.children)  {|c|
    json.extract! c, :id,:name
  }
end