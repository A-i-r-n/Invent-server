json.extract! product, :id,:name,:price,:has_variants,:weight,:created_at, :updated_at
attachment = product.attachments.order(id: :asc).first
if attachment.present? && attachment.image?
  json.image_url image_url(attachment.file.url)
end
json.parent_id product.parent_id if product.variant?

json.attributes(product.product_attributes) do |attribute|
  json.extract! attribute,:id,:key,:value,:position
end