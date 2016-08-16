json.extract! lottery, :id,:name,:periods,:max_periods,:price,:participants,:max_participants,:description

image = lottery.default_image
if image then json.image_url image_url(image.file.url) end