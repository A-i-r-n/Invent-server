json.extract! vendor, :id,:name,:grade_num,:grade_score,:distance,:location,:address,:sold_num,:keywords,:created_at, :updated_at

licence_attachment = vendor.licence_image
if licence_attachment then json.licence_image_url image_url(licence_attachment.file.url) end

default_attachment = vendor.default_image
if default_attachment then json.image_url image_url(default_attachment.file.url) end

if vendor.product_category.present? then
  json.set! 'category' do
    json.partial! 'jshare/category' ,category: vendor.product_category
  end
end
