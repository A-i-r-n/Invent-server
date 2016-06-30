json.code 0 if @uploads.count>0
json.data(@uploads) do |upload|
	json.extract! upload, :created_at, :updated_at
	json.image image_url(upload.uploaded_file(:large))
	json.code "app"
	json.status 1 if upload
	json.link "none"
end