# encoding: UTF-8

def get_file(name, content_type = 'image/jpeg')
  file = ActionDispatch::Http::UploadedFile.new(tempfile: File.open(File.join(Rails.root, 'db', 'seeds_data', name), 'rb'))
  file.original_filename = name
  file.content_type = content_type
  file
end

banner = Banner.create(name:"banner",link:"link")
banner_attachment = Attachment.new(file: get_file('banner01.jpg'), role: 'default_image')
banner.attachment = banner_attachment
banner_attachment.save

CountryImporter.import

AreaImporter.import

admin_cat1 = ProductCategory.where(name: '美食').first_or_create
admin_cat1.attachments.build(file: get_file('index_food.png'), role: 'default_image').save
#美食下分类
admin_cat1_1 = ProductCategory.where(name: '自助餐').first_or_create
admin_cat1_1.parent = admin_cat1
admin_cat1_1.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat1_1.save

admin_cat1_2 = ProductCategory.where(name: '小吃快餐').first_or_create
admin_cat1_2.parent = admin_cat1
admin_cat1_2.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat1_2.save

admin_cat1_3 = ProductCategory.where(name: '甜点饮品').first_or_create
admin_cat1_3.parent = admin_cat1
admin_cat1_3.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat1_3.save

admin_cat1_4 = ProductCategory.where(name: '江浙菜').first_or_create
admin_cat1_4.parent = admin_cat1
admin_cat1_4.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat1_4.save

admin_cat1_5 = ProductCategory.where(name: '生日蛋糕').first_or_create
admin_cat1_5.parent = admin_cat1
admin_cat1_5.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat1_5.save

admin_cat1_6 = ProductCategory.where(name: '火锅').first_or_create
admin_cat1_6.parent = admin_cat1
admin_cat1_6.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat1_6.save


admin_cat2 = ProductCategory.where(name: '酒店').first_or_create
admin_cat2.attachments.build(file: get_file('index_hotel.png'), role: 'default_image').save


admin_cat3 = ProductCategory.where(name: '娱乐').first_or_create
admin_cat3.attachments.build(file: get_file('index_amuse.png'), role: 'default_image').save

#娱乐分类
admin_cat3_1 = ProductCategory.where(name: '酒吧').first_or_create
admin_cat3_1.parent = admin_cat3
admin_cat3_1.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat3_1.save

admin_cat3_2 = ProductCategory.where(name: 'KTV').first_or_create
admin_cat3_2.parent = admin_cat3
admin_cat3_2.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat3_2.save

admin_cat3_3 = ProductCategory.where(name: '农家乐').first_or_create
admin_cat3_3.parent = admin_cat3
admin_cat3_3.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat3_3.save

admin_cat3_4 = ProductCategory.where(name: 'DIY手工').first_or_create
admin_cat3_4.parent = admin_cat3
admin_cat3_4.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat3_4.save


admin_cat4 = ProductCategory.where(name: '丽人').first_or_create
admin_cat4.attachments.build(file: get_file('index_bauty.png'), role: 'default_image').save

#丽人下分类
admin_cat4_1 = ProductCategory.where(name: '美发').first_or_create
admin_cat4_1.parent = admin_cat4
admin_cat4_1.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat4_1.save

admin_cat4_2 = ProductCategory.where(name: '美容美体').first_or_create
admin_cat4_2.parent = admin_cat4
admin_cat4_2.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat4_2.save

admin_cat4_3 = ProductCategory.where(name: '美甲美睫').first_or_create
admin_cat4_3.parent = admin_cat4
admin_cat4_3.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat4_3.save

admin_cat4_4 = ProductCategory.where(name: '瘦身纤体').first_or_create
admin_cat4_4.parent = admin_cat4
admin_cat4_4.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat4_4.save

admin_cat4_5 = ProductCategory.where(name: '纹身').first_or_create
admin_cat4_5.parent = admin_cat4
admin_cat4_5.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat4_5.save

admin_cat4_6 = ProductCategory.where(name: '祛痘').first_or_create
admin_cat4_6.parent = admin_cat4
admin_cat4_6.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat4_6.save


admin_cat5 = ProductCategory.where(name: '母婴').first_or_create
admin_cat5.attachments.build(file: get_file('index_mother.png'), role: 'default_image').save

#母婴分类
admin_cat5_1 = ProductCategory.where(name: '儿童乐园').first_or_create
admin_cat5_1.parent = admin_cat5
admin_cat5_1.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat5_1.save

admin_cat5_2 = ProductCategory.where(name: '儿童摄影').first_or_create
admin_cat5_2.parent = admin_cat5
admin_cat5_2.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat5_2.save

admin_cat5_3 = ProductCategory.where(name: '幼儿教育').first_or_create
admin_cat5_3.parent = admin_cat5
admin_cat5_3.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat5_3.save

admin_cat5_4 = ProductCategory.where(name: '母婴护理').first_or_create
admin_cat5_4.parent = admin_cat5
admin_cat5_4.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat5_4.save

admin_cat5_5 = ProductCategory.where(name: '孕妇写真').first_or_create
admin_cat5_5.parent = admin_cat5
admin_cat5_5.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat5_5.save

admin_cat5_6 = ProductCategory.where(name: '婴儿游泳').first_or_create
admin_cat5_6.parent = admin_cat5
admin_cat5_6.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat5_6.save

admin_cat6 = ProductCategory.where(name: '超市').first_or_create
admin_cat6.attachments.build(file: get_file('index_market.png'), role: 'default_image').save

admin_cat7 = ProductCategory.where(name: '服饰').first_or_create
admin_cat7.attachments.build(file: get_file('index_clothes.png'), role: 'default_image').save

#服饰
admin_cat7_1 = ProductCategory.where(name: '儿童').first_or_create
admin_cat7_1.parent = admin_cat7
admin_cat7_1.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat7_1.save

admin_cat7_2 = ProductCategory.where(name: '青年').first_or_create
admin_cat7_2.parent = admin_cat7
admin_cat7_2.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat7_2.save

admin_cat7_3 = ProductCategory.where(name: '中年').first_or_create
admin_cat7_3.parent = admin_cat7
admin_cat7_3.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat7_3.save

admin_cat7_4 = ProductCategory.where(name: '老年').first_or_create
admin_cat7_4.parent = admin_cat7
admin_cat7_4.attachments.build(file: get_file('index_bauty.png'), role: 'default_image')
admin_cat7_4.save


admin_cat8 = ProductCategory.where(name: '其他').first_or_create
admin_cat8.attachments.build(file: get_file('index_service.png'), role: 'default_image').save


admin_profile = Profile.create(label: 'admin', nicename: 'admin',
                               modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :themes, :sidebar, :profile, :users, :settings, :seo])
vendor_profile = Profile.create(label: 'vendor', nicename: 'vendor',
                                modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :profile])
customer_profile = Profile.create(label: 'customer', nicename: 'customer',
                                  modules: [:dashboard, :profile ])

admin_user = User.create(login: 'customer', password: '123456',verify_password:'123456')
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

lottery = Lottery.create(name: "test001",price: 1,periods: 0,max_periods: 10,participants: 0,max_participants:10,description: "this is test001",end_time: Time.now + 5.days)
lottery.default_image_file = get_file('snom-870-grey.jpg')
lottery.save

LotteryRecord.create(code: '0000',periods: 1,user: customer_user,campaign: lottery)

coupon = Coupon.create(vendor: vendor,product_category: admin_cat1,amount:100,exceed_val:1,val: 100,coupon_type: 'full')

mall_item = MallItem.create(name: "test001",price: 1,periods: 0,max_periods: 10,participants: 0,max_participants:10,description: "this is test001")
mall_item.default_image_file = get_file('snom-870-grey.jpg')
mall_item.save

seller_cat_group = ProductCategory.where(name: '电话group',vendor: vendor).first_or_create

agglomeration = Agglomeration.new(name: "agg_001",price: 1,periods: 0,max_periods: 10,participants: 0,max_participants:10,description: "this is test001",end_time: Time.now + 5.days)
agglomeration.default_image_file = get_file('snom-870-grey.jpg')
agglomeration.vendor = vendor
agglomeration.product_category = seller_cat_group
agglomeration.save

vendor.role << 'agglomeration'
vendor.save


job_category1 = JobCategory.where(name: '出租').first_or_create
job_category2 = JobCategory.where(name: '求租').first_or_create
job_category3 = JobCategory.where(name: '招聘').first_or_create
job_category4 = JobCategory.where(name: '求职').first_or_create

job = Job.create(name: "job_001",price: 1,periods: 0,max_periods: 10,participants: 0,max_participants:10,description: "this is test001")
job.default_image_file = get_file('snom-870-grey.jpg')
job.category = job_category1
job.save


Message.create(phone: '18868945291',content:'恭喜你,你已注册成功',message_type: 'push',user: customer_user)

bag1 = Bag.create(name:"单肩包",price:"123",explain:"这是款很好看的包",color:"白色")
bag1_attachment = Attachment.new(file: get_file('banner01.jpg'), role: 'default_image')
bag1.attachment = bag1_attachment
bag1_attachment.save


bag2 = Bag.create(name:"双肩包",price:"345",explain:"这款包很大气",color:"红色")
bag2_attachment = Attachment.new(file: get_file('banner01.jpg'), role: 'default_image')
bag2.attachment = bag2_attachment
bag2_attachment.save

shoe1 = Shoe.create(name:"鞋子1",price:"123",height:"12",color:"白色")
shoe1.attachment = Attachment.new(file: get_file('banner01.jpg'), role: 'default_image')


shoe2 = Shoe.create(name:"鞋子2",price:"443",height:"10",color:"蓝色")
shoe2.attachment = Attachment.new(file: get_file('snom-870-grey.jpg'), role: 'default_image')

cosmetic1 = Cosmetic.create(name:"拉美拉折叠修眉刀",price:"9.9",explain:"锋利,安全,画眉专业,刮眉刀片.女用美妆工具")
cosmetic1.attachment = Attachment.new(file:get_file("banner01.jpg"),role:"default_image")

cosmetic1 = Cosmetic.create(name:"萌黛儿化妆棉",price:"19.9",explain:"卸妆美容补水工具,纯棉双面双效200片")
cosmetic1.attachment = Attachment.new(file:get_file("banner01.jpg"),role:"default_image")

music1 = Music.create(name:"同桌的你",price:"19.9",explain:"梦回校园")
music1.attachment = Attachment.new(file:get_file("banner01.jpg"),role:"default_image")