json.code (@job_categories ? 0 : 1)
json.data do
  json.list(@job_categories) do |category|
    json.partial! 'jshare/category',category: category
  end
end