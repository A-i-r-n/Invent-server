json.code (@unboxing ? 0 : 1)
json.data do
  json.partial! 'jshare/unboxing',unboxing: @unboxing
end