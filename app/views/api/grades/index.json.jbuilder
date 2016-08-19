json.code (@grades ? 0 : 1)
json.data do
  json.list(@grades) do |grade|
    json.partial! 'jshare/grade',grade: grade
  end
  json.partial! 'jshare/page',model: @grades
end