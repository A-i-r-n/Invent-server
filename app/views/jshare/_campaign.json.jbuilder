json.extract! campaign, :id,:name,:periods,:max_periods,:price,:participants,:max_participants,:description

image = campaign.default_image
if image then json.image_url image_url(image.file.url) end