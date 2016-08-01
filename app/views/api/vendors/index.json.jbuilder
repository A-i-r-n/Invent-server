json.code (@vendors ? 0 : 1)
json.data do
  json.list(@vendors) do |vendor|
    json.partial! 'jshare/vendor', vendor: vendor
  end
  json.page params[:page]
end