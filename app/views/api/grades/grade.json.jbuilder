json.code (@grade ? 0 : 1)
json.data do
  json.partial! 'jshare/grade',grade: @grade
end