json.code (@unboxings ? 0 : 1)
json.data do
  json.list(@unboxings) do |unboxing|
    json.partial! 'jshare/unboxing',unboxing: unboxing
  end
  json.partial! 'jshare/page',model: @unboxings
end