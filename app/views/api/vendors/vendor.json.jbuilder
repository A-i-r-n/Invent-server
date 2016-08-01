json.code (@vendor ? 0 : 1)
json.data do
  json.partial! 'jshare/vendor', vendor: @vendor
end