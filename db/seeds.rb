# encoding: UTF-8

def get_file(name, content_type = 'image/jpeg')
  file = ActionDispatch::Http::UploadedFile.new(tempfile: File.open(File.join(Rails.root, 'db', 'seeds_data', name), 'rb'))
  file.original_filename = name
  file.content_type = content_type
  file
end

banner = Banner.create(name:"banner",link:"link")
banner_attachment = Attachment.new(file: get_file('test_index_banner.png'), role: 'default_image')
banner.attachment = banner_attachment
banner_attachment.save

CountryImporter.import

AreaImporter.import

admin_cat1 = ProductCategory.where(name: '美食').first_or_create
admin_cat1.attachments.build(file: get_file('index_food.png'), role: 'default_image').save

admin_cat2 = ProductCategory.where(name: '酒店').first_or_create
admin_cat2.attachments.build(file: get_file('index_hotel.png'), role: 'default_image').save

admin_cat3 = ProductCategory.where(name: '娱乐').first_or_create
admin_cat3.attachments.build(file: get_file('index_amuse.png'), role: 'default_image').save

admin_cat4 = ProductCategory.where(name: '丽人').first_or_create
admin_cat4.attachments.build(file: get_file('index_bauty.png'), role: 'default_image').save

admin_cat5 = ProductCategory.where(name: '母婴').first_or_create
admin_cat5.attachments.build(file: get_file('index_mother.png'), role: 'default_image').save

admin_cat6 = ProductCategory.where(name: '超市').first_or_create
admin_cat6.attachments.build(file: get_file('index_market.png'), role: 'default_image').save

admin_cat7 = ProductCategory.where(name: '服饰').first_or_create
admin_cat7.attachments.build(file: get_file('index_clothes.png'), role: 'default_image').save

admin_cat8 = ProductCategory.where(name: '其他').first_or_create
admin_cat8.attachments.build(file: get_file('index_service.png'), role: 'default_image').save


admin_profile = Profile.create(label: 'admin', nicename: 'admin',
                               modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :themes, :sidebar, :profile, :users, :settings, :seo])
vendor_profile = Profile.create(label: 'vendor', nicename: 'vendor',
                                modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :profile])
customer_profile = Profile.create(label: 'customer', nicename: 'customer',
                                  modules: [:dashboard, :profile ])

admin_user = User.create(login: 'admin', password: '123456',verify_password:'123456')
admin_user.profile_ids = admin_profile.id

vendor = Vendor.create(name:"vendor",grade_num:0,grade_score:0.0,pid:1,cid:2,status:'accepted')
vendor.attachments.build(file: get_file('t22p.jpg'), role: 'default_image')
vendor.product_category_id = admin_cat1.id
vendor.save
vendor_user = User.create(login: 'vendor', password: '123456',verify_password:'123456',vendor: vendor)
vendor_user.profile_ids = vendor_profile.id
vendor_user.save

customer = Customer.create(first_name:"customer",last_name:"customer",company:"company",email:"948993066@qq.com",phone:"18868945291",mobile:"18868945291")
customer_user = User.create(login: 'customer', password: '123456',verify_password:'123456',phone:'18868945291',real_name:"陈中杭",idcard:"330124199111141812",customer: customer)
customer_user.profile_ids = customer_profile.id
customer_user.save

address = Address.create(customer:customer,name: "陈中杭",phone: "18868945291",address_type:'billing',default: 1,address1:"no need",address2:"no need",
                      address3:"no need",address4:"no need",postcode:"311311",country_id:15,pid:1,cid:2)

# tax rates
tax_rate = TaxRate.where(name: 'Standard VAT', rate: 20.0).first_or_create

# delivery services
ds = DeliveryService.new(name: 'Next Day Delivery', code: 'ND16', courier: 'AnyCourier', tracking_url: 'http://trackingurl.com/track/{{consignment_number}}')
if ds.save
  ds.delivery_service_prices.create(code: 'Parcel', min_weight: 0, max_weight: 1, price: 5.0, cost_price: 4.50, tax_rate: tax_rate)
  ds.delivery_service_prices.create(code: 'Parcel', min_weight: 1, max_weight: 5, price: 8.0, cost_price: 7.5, tax_rate: tax_rate)
  ds.delivery_service_prices.create(code: 'Parcel', min_weight: 5, max_weight: 20, price: 10.0, cost_price: 9.50, tax_rate: tax_rate)
end

ds = DeliveryService.new(name: 'Saturday Delivery', code: 'NDSA16', courier: 'AnyCourier', tracking_url: 'http://trackingurl.com/track/{{consignment_number}}')
if ds.save
  ds.delivery_service_prices.create(code: 'Parcel', min_weight: 0, max_weight: 1, price: 27.0, cost_price: 24.00, tax_rate: tax_rate)
  ds.delivery_service_prices.create(code: 'Parcel', min_weight: 1, max_weight: 5, price: 29.0, cost_price: 20.00, tax_rate: tax_rate)
  ds.delivery_service_prices.create(code: 'Parcel', min_weight: 5, max_weight: 20, price: 37.0, cost_price: 32.00, tax_rate: tax_rate)
end

# categories
# cat1 = ProductCategory.create(name: '电话',vendor: vendor,permalink:"permalink")
# cat1.save(validate:false)



seller_cat1 = ProductCategory.where(name: '电话',vendor: vendor).first_or_create


lorem = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
         eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim
         ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
         aliquip ex ea commodo consequat. Duis aute irure dolor in
         reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
         pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
         culpa qui officia deserunt mollit anim id est laborum.'
carriage_template = CarriageTemplate.new(name:"carriage_template")

if carriage_template.save
  carriage_template.carriage_template_prices.create(key:"carriage_template_price",start: 1, plus:1,postage: 1,postageplus: 1,
                                           express_areas_ids:"2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19",
                                           express_areas_names:"东城区,西城区,崇文区,宣武区,朝阳区,丰台区,石景山区,海淀区,门头沟区,房山区,通州区,顺义区,昌平区,大兴区,平谷区,怀柔区,密云县,延庆县")
end

pro = Product.new(carriage_template: carriage_template,vendor: vendor,name: 'Yealink T20P', sku: 'YL-SIP-T20P', description: lorem, short_description: 'If cheap & cheerful is what you’re after, the Yealink T20P is what you’re looking for.', weight: 1.119, price: 54.99, cost_price: 44.99, tax_rate: tax_rate, featured: true)
pro.product_category_ids = seller_cat1.id
pro.product_category_id  = admin_cat1.id
pro.default_image_file = get_file('t20p.jpg')
if pro.save
  pro.stock_level_adjustments.create(description: 'Initial Stock', adjustment: 17)
  attr1 = pro.product_attributes.create(key: '颜色', value: '红色', position: 1)
  attr2 = pro.product_attributes.create(key: '颜色', value: '白色', position: 1)
  attr3 = pro.product_attributes.create(key: '大小', value: '12', position: 1)
  attr4 = pro.product_attributes.create(key: '大小', value: '15', position: 1)

  v1 = pro.variants.create(name: 'White/Grey', sku: 'SM-870-GREY', price: 230.00, cost_price: 220, tax_rate: tax_rate, weight: 1.35, default: true)
  v1.default_image_file = get_file('snom-870-grey.jpg')
  v1.product_attribute_ids = attr1.id,attr3.id
  if v1.save
    v1.stock_level_adjustments.create(description: 'Initial Stock', adjustment: 4)
  end

  v2 = pro.variants.create(name: 'Black', sku: 'SM-870-BLK', price: 230.00, cost_price: 220, tax_rate: tax_rate, weight: 1.35)
  v2.default_image_file = get_file('snom-870-blk.jpg')
  v2.product_attribute_ids = attr2.id,attr4.id
  if v2.save
    v2.stock_level_adjustments.create(description: 'Initial Stock', adjustment: 2)
  end
end

Message.create(phone: '18868945291',content:'jpush test',message_type: Message::PUSH_ORDER,user: customer_user)

lottery = Lottery.create(name: "test001",price: 1,periods: 0,max_periods: 10,participants: 0,max_participants:10,description: "this is test001")
lottery.default_image_file = get_file('snom-870-grey.jpg')
lottery.save


# pro = Product.new(carriage_template: carriage_template,vendor: vendor,name: 'Yealink T22P', sku: 'YL-SIP-T22P', description: lorem, short_description: lorem, weight: 1.419, price: 64.99, cost_price: 56.99, tax_rate: tax_rate)
# pro.product_category_ids = cat1.id
# pro.default_image_file = get_file('t22p.jpg')
# if pro.save
#   pro.stock_level_adjustments.create(description: 'Initial Stock', adjustment: 200)
#   pro.product_attributes.create(key: 'Manufacturer', value: 'Yealink', position: 1)
#   pro.product_attributes.create(key: 'Model', value: 'T22P', position: 1)
#   pro.product_attributes.create(key: 'Colour', value: 'Black', position: 1)
#   pro.product_attributes.create(key: 'Lines', value: '4', position: 1)
#   pro.product_attributes.create(key: 'Colour Screen?', value: 'No', position: 1)
#   pro.product_attributes.create(key: 'Power over ethernet?', value: 'Yes', position: 1)
# end
#
# pro = Product.new(carriage_template: carriage_template,vendor: vendor,name: 'Yealink T26P', sku: 'YL-SIP-T26P', description: lorem, short_description: lorem, weight: 2.23, price: 88.99, cost_price: 78.99, tax_rate: tax_rate)
# pro.product_category_ids = cat1.id
# pro.default_image_file = get_file('t26p.jpg')
# if pro.save
#   pro.stock_level_adjustments.create(description: 'Initial Stock', adjustment: 100)
#   pro.product_attributes.create(key: 'Manufacturer', value: 'Yealink', position: 1)
#   pro.product_attributes.create(key: 'Model', value: 'T26P', position: 1)
#   pro.product_attributes.create(key: 'Colour', value: 'Black', position: 1)
#   pro.product_attributes.create(key: 'Lines', value: '6', position: 1)
#   pro.product_attributes.create(key: 'Colour Screen?', value: 'No', position: 1)
#   pro.product_attributes.create(key: 'Power over ethernet?', value: 'Yes', position: 1)
# end
#
# pro = Product.new(carriage_template: carriage_template,vendor: vendor,name: 'Yealink T46GN', sku: 'YL-SIP-T46GN', description: lorem, short_description: 'Colourful, sharp, fast & down right sexy. The Yealink T46P will make your scream', weight: 2.23, price: 149.99, cost_price: 139.99, tax_rate: tax_rate, featured: true)
# pro.product_category_ids = cat1.id
# pro.default_image_file = get_file('t46gn.jpg')
# if pro.save
#   pro.stock_level_adjustments.create(description: 'Initial Stock', adjustment: 10)
#   pro.product_attributes.create(key: 'Manufacturer', value: 'Yealink', position: 1)
#   pro.product_attributes.create(key: 'Model', value: 'T46GN', position: 1)
#   pro.product_attributes.create(key: 'Colour', value: 'Black', position: 1)
#   pro.product_attributes.create(key: 'Lines', value: '4', position: 1)
#   pro.product_attributes.create(key: 'Colour Screen?', value: 'Yes', position: 1)
#   pro.product_attributes.create(key: 'Power over ethernet?', value: 'Yes', position: 1)
# end
#
# pro = Product.new(carriage_template: carriage_template,vendor: vendor,name: 'Snom 870', sku: 'SM-870', description: lorem, short_description: 'The perfect & beautiful VoIP phone for the discerning professional desk.', featured: true)
# pro.product_category_ids = cat1.id
# pro.default_image_file = get_file('snom-870-grey.jpg')
# if pro.save
#   pro.product_attributes.create(key: 'Manufacturer', value: 'Snom', position: 1)
#   pro.product_attributes.create(key: 'Model', value: '870', position: 1)
#   pro.product_attributes.create(key: 'Colour', value: 'Grey', position: 1)
#   pro.product_attributes.create(key: 'Lines', value: '10', position: 1)
#   pro.product_attributes.create(key: 'Colour Screen?', value: 'Yes', position: 1)
#   pro.product_attributes.create(key: 'Power over ethernet?', value: 'Yes', position: 1)
#
#   v1 = pro.variants.create(name: 'White/Grey', sku: 'SM-870-GREY', price: 230.00, cost_price: 220, tax_rate: tax_rate, weight: 1.35, default: true)
#   v1.default_image_file = get_file('snom-870-grey.jpg')
#   if v1.save
#     v1.stock_level_adjustments.create(description: 'Initial Stock', adjustment: 4)
#   end
#
#   v2 = pro.variants.create(name: 'Black', sku: 'SM-870-BLK', price: 230.00, cost_price: 220, tax_rate: tax_rate, weight: 1.35)
#   v2.default_image_file = get_file('snom-870-blk.jpg')
#   if v2.save
#     v2.stock_level_adjustments.create(description: 'Initial Stock', adjustment: 2)
#   end
# end
#
# pro = Product.new(carriage_template: carriage_template,vendor: vendor,name: 'Yealink Mono Headset', sku: 'YL-YHS32', description: lorem, short_description: 'If you\'re often on the phone, this headset will make your life 100x easier. Guaranteed*.', weight: 0.890, price: 34.99, cost_price: 24.99, tax_rate: tax_rate, featured: true)
# pro.product_category_ids = cat2.id
# pro.default_image_file = get_file('yhs32.jpg')
# if pro.save
#   pro.product_attributes.create(key: 'Manufacturer', value: 'Yealink', position: 1)
#   pro.product_attributes.create(key: 'Model', value: 'YHS32', position: 1)
# end
#
# pro = Product.new(carriage_template: carriage_template,vendor: vendor,name: 'Snom Wired Headset (MM2)', sku: 'SM-MM2', description: lorem, short_description: lorem, weight: 0.780, price: 38.00, cost_price: 30, tax_rate: tax_rate)
# pro.product_category_ids = cat2.id
# pro.default_image_file = get_file('snom-mm2.jpg')
# if pro.save
#   pro.stock_level_adjustments.create(description: 'Initial Stock', adjustment: 7)
#   pro.product_attributes.create(key: 'Manufacturer', value: 'Snom', position: 1)
#   pro.product_attributes.create(key: 'Model', value: 'MM2', position: 1)
# end
#
# pro = Product.new(carriage_template: carriage_template,vendor: vendor,name: 'Snom Wired Headset (MM3)', sku: 'SM-MM3', description: lorem, short_description: lorem, weight: 0.780, price: 38.00, cost_price: 30, tax_rate: tax_rate)
# pro.product_category_ids = cat2.id
# pro.default_image_file = get_file('snom-mm2.jpg')
# if pro.save
#   pro.stock_level_adjustments.create(description: 'Initial Stock', adjustment: 5)
#   pro.product_attributes.create(key: 'Manufacturer', value: 'Snom', position: 1)
#   pro.product_attributes.create(key: 'Model', value: 'MM3', position: 1)
# end
#
# pro = Product.new(carriage_template: carriage_template,vendor: vendor,name: 'Yealink W52P', sku: 'TL-SIP-W52P', description: lorem, short_description: 'Wireless SIP phones are hard to come by but this beauty from Yealink is fab.', weight: 1.280, price: 99.99, cost_price: 89.99, tax_rate: tax_rate, featured: true)
# pro.product_category_ids = cat1.id
# pro.default_image_file = get_file('w52p.jpg')
# if pro.save
#   pro.stock_level_adjustments.create(description: 'Initial Stock', adjustment: 10)
#   pro.product_attributes.create(key: 'Manufacturer', value: 'Snom', position: 1)
#   pro.product_attributes.create(key: 'Model', value: 'W52P', position: 1)
#   pro.product_attributes.create(key: 'Lines', value: '3', position: 1)
#   pro.product_attributes.create(key: 'Colour Screen?', value: 'Yes', position: 1)
#   pro.product_attributes.create(key: 'Power over ethernet?', value: 'No', position: 1)
# end
