json.code (@areas ? 0 : 1)
json.data do
  json.list(@areas)  do |area|
    json.extract! area, :id,:name,:has_children
  end
  json.partial! 'jshare/page',model: @areas
end