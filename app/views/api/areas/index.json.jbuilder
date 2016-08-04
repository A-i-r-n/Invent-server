json.code (@areas ? 0 : 1)
json.data do
  json.list(@areas)  {|area|
    json.extract! area, :id,:name,:has_children
  }
end