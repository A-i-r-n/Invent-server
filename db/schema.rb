# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160704054721) do

  create_table "addresses", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "phone",      limit: 255
    t.integer  "customer_id",  limit: 4
    t.string   "address_type", limit: 255
    t.boolean  "default"
    t.string   "address1",     limit: 255
    t.string   "address2",     limit: 255
    t.string   "address3",     limit: 255
    t.string   "address4",     limit: 255
    t.string   "postcode",     limit: 255
    t.integer  "country_id",   limit: 4
    # t.integer  "area_id",   limit: 4
    t.integer  "pid",  limit: 4
    t.integer  "cid",  limit: 4
    t.integer  "sid",  limit: 4
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

  add_index "addresses", ["customer_id"], name: "index_addresses_on_customer_id", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.integer  "parent_id",   limit: 4,   null: false
    t.string   "parent_type", limit: 255, null: false
    t.string   "token",       limit: 255
    t.string   "file",        limit: 255, null: false
    t.string   "file_name",   limit: 255
    t.integer  "file_size",   limit: 4
    t.string   "file_type",   limit: 255
    t.string   "role",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: :cascade do |t|
    t.string  "name",      limit: 255
    t.string  "code2",     limit: 255
    t.string  "code3",     limit: 255
    t.string  "continent", limit: 255
    t.string  "tld",       limit: 255
    t.string  "currency",  limit: 255
    t.boolean "eu_member",             default: false
  end

  create_table "areas", force: :cascade do |t|
    t.string  "name",      limit: 255
    t.string  "code2",     limit: 255
    t.string  "code3",     limit: 255
    t.string  "continent", limit: 255
    t.string  "currency",  limit: 255
    t.boolean "eu_member",             default: false
    t.integer "parent_id", limit: 4
    t.integer  "lft",                          limit: 4
    t.integer  "rgt",                          limit: 4
  end

  create_table "customers", force: :cascade do |t|
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.string   "company",    limit: 255
    t.string   "email",      limit: 255
    t.string   "phone",      limit: 255
    t.string   "mobile",     limit: 255
    t.integer  "user_id", limit:4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivery_service_prices", force: :cascade do |t|
    t.integer  "delivery_service_id", limit: 4
    t.string   "code",                limit: 255
    t.decimal  "price",                             precision: 8, scale: 2
    t.decimal  "cost_price",                        precision: 8, scale: 2
    t.integer  "tax_rate_id",         limit: 4
    t.decimal  "min_weight",                        precision: 8, scale: 2
    t.decimal  "max_weight",                        precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "country_ids",         limit: 65535
  end

  add_index "delivery_service_prices", ["delivery_service_id"], name: "index_delivery_service_prices_on_delivery_service_id", using: :btree
  add_index "delivery_service_prices", ["max_weight"], name: "index_delivery_service_prices_on_max_weight", using: :btree
  add_index "delivery_service_prices", ["min_weight"], name: "index_delivery_service_prices_on_min_weight", using: :btree
  add_index "delivery_service_prices", ["price"], name: "index_delivery_service_prices_on_price", using: :btree

  create_table "delivery_services", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "code",         limit: 255
    t.boolean  "default",                  default: false
    t.boolean  "active",                   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "courier",      limit: 255
    t.string   "tracking_url", limit: 255
  end

  add_index "delivery_services", ["active"], name: "index_delivery_services_on_active", using: :btree

  create_table "carriage_templates", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "valuation",   limit: 4
    t.boolean  "active",                   default: true
    # t.integer "product_id", limit:4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carriage_template_prices", force: :cascade do |t|
    t.string    "key",                          limit:  255
    t.decimal   "start",                        precision: 8, scale: 2
    t.decimal   "plus",                         precision: 8, scale: 2
    t.decimal   "postage",                      precision: 8, scale: 2
    t.decimal   "postageplus",                  precision: 8, scale: 2
    t.text      "express_areas_ids",                        limit: 65535
    t.text      "express_areas_names",                      limit: 65535
    t.integer   "carriage_template_id",                     limit:4
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

  create_table "nifty_key_value_store", force: :cascade do |t|
    t.integer "parent_id",   limit: 4
    t.string  "parent_type", limit: 255
    t.string  "group",       limit: 255
    t.string  "name",        limit: 255
    t.string  "value",       limit: 255
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id",          limit: 4
    t.integer  "ordered_item_id",   limit: 4
    t.string   "ordered_item_type", limit: 255
    t.integer  "quantity",          limit: 4,                           default: 1
    t.decimal  "unit_price",                    precision: 8, scale: 2
    t.decimal  "unit_cost_price",               precision: 8, scale: 2
    t.decimal  "tax_amount",                    precision: 8, scale: 2
    t.decimal  "tax_rate",                      precision: 8, scale: 2
    t.decimal  "weight",                        precision: 8, scale: 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree
  add_index "order_items", ["ordered_item_id", "ordered_item_type"], name: "index_order_items_ordered_item", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "token",                     limit: 255
    t.string   "first_name",                limit: 255
    t.string   "last_name",                 limit: 255
    t.string   "company",                   limit: 255
    t.string   "billing_address1",          limit: 255
    t.string   "billing_address2",          limit: 255
    t.string   "billing_address3",          limit: 255
    t.string   "billing_address4",          limit: 255
    t.string   "billing_postcode",          limit: 255
    t.integer  "billing_country_id",        limit: 4
    t.string   "email_address",             limit: 255
    t.string   "phone_number",              limit: 255
    t.string   "status",                    limit: 255
    t.datetime "received_at"
    t.datetime "accepted_at"
    t.datetime "shipped_at"
    t.decimal  "delivery_price",                          precision: 8, scale: 2
    t.decimal  "delivery_cost_price",                     precision: 8, scale: 2
    t.decimal  "carriage_price",                     precision: 8, scale: 2
    t.decimal  "delivery_tax_rate",                       precision: 8, scale: 2
    t.decimal  "delivery_tax_amount",                     precision: 8, scale: 2
    t.integer  "accepted_by",               limit: 4
    t.integer  "shipped_by",                limit: 4
    t.string   "consignment_number",        limit: 255
    t.datetime "rejected_at"
    t.integer  "rejected_by",               limit: 4
    t.string   "ip_address",                limit: 255
    t.text     "notes",                     limit: 65535
    t.boolean  "separate_delivery_address",                                       default: false
    t.string   "delivery_name",             limit: 255
    t.string   "delivery_address1",         limit: 255
    t.string   "delivery_address2",         limit: 255
    t.string   "delivery_address3",         limit: 255
    t.string   "delivery_address4",         limit: 255
    t.string   "delivery_postcode",         limit: 255
    t.decimal  "amount_paid",                             precision: 8, scale: 2, default: 0.0
    t.boolean  "exported",                                                        default: false
    t.string   "invoice_number",            limit: 255
    t.integer  "customer_id",               limit: 4
    t.integer  "address_id",                limit: 4
    t.integer  "vendor_id",                 limit: 4
    t.integer  "delivery_service_id",       limit: 4
    t.integer  "delivery_country_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["delivery_service_id"], name: "index_orders_on_delivery_service_id", using: :btree
  add_index "orders", ["received_at"], name: "index_orders_on_received_at", using: :btree
  add_index "orders", ["token"], name: "index_orders_on_token", using: :btree

  create_table "payments", force: :cascade do |t|
    # t.integer  "order_id",          limit: 4
    t.integer  "item_id",          limit: 4
    t.string   "item_type",        limit: 255
    t.decimal  "amount",                        precision: 8, scale: 2, default: 0.0
    t.string   "no",               limit: 255
    t.string   "reference",         limit: 255
    t.string   "method",            limit: 255
    t.boolean  "confirmed",                                             default: false
    t.boolean  "refundable",                                            default: false
    t.decimal  "amount_refunded",               precision: 8, scale: 2, default: 0.0
    t.integer  "parent_payment_id", limit: 4
    t.boolean  "exported",                                              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # add_index "payments", ["order_id"], name: "index_payments_on_order_id", using: :btree
  add_index "payments", ["parent_payment_id"], name: "index_payments_on_parent_payment_id", using: :btree

  create_table "product_attributes", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.string   "value",      limit: 255
    t.integer  "position",   limit: 4,   default: 1
    t.boolean  "searchable",             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",                 default: true
  end

  create_table "product_attributions", force: :cascade do |t|
    t.integer "product_id",          limit: 4, null: false
    t.integer "product_attribute_id", limit: 4, null: false
  end

  add_index "product_attributes", ["key"], name: "index_product_attributes_on_key", using: :btree
  add_index "product_attributes", ["position"], name: "index_product_attributes_on_position", using: :btree
  # add_index "product_attributes", ["product_id"], name: "index_product_attributes_on_product_id", using: :btree

  create_table "product_categories", force: :cascade do |t|
    t.string   "name",                         limit: 255
    t.string   "permalink",                    limit: 255
    t.text     "description",                  limit: 65535
    t.integer  "parent_id",                    limit: 4
    t.integer  "lft",                          limit: 4
    t.integer  "rgt",                          limit: 4
    t.integer  "depth",                        limit: 4
    t.string   "ancestral_permalink",          limit: 255
    t.boolean  "permalink_includes_ancestors",               default: false
    t.integer  "vendor_id",                    limit:4
    t.datetime "created_at"
    t.datetime "updated_at"
  end


  add_index "product_categories", ["lft"], name: "index_product_categories_on_lft", using: :btree
  add_index "product_categories", ["permalink"], name: "index_product_categories_on_permalink", using: :btree
  add_index "product_categories", ["rgt"], name: "index_product_categories_on_rgt", using: :btree

  create_table "product_categorizations", force: :cascade do |t|
    t.integer "product_id",          limit: 4, null: false
    t.integer "product_category_id", limit: 4, null: false
  end

  add_index "product_categorizations", ["product_category_id"], name: "categorization_by_product_category_id", using: :btree
  add_index "product_categorizations", ["product_id"], name: "categorization_by_product_id", using: :btree

  create_table "product_category_translations", force: :cascade do |t|
    t.integer  "product_category_id", limit: 4,     null: false
    t.string   "locale",              limit: 255,   null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "name",                limit: 255
    t.string   "permalink",           limit: 255
    t.text     "description",         limit: 65535
  end

  add_index "product_category_translations", ["locale"], name: "index_product_category_translations_on_locale", using: :btree
  add_index "product_category_translations", ["product_category_id"], name: "index_75826cc72f93d014e54dc08b8202892841c670b4", using: :btree

  create_table "product_translations", force: :cascade do |t|
    t.integer  "product_id",        limit: 4,     null: false
    t.string   "locale",            limit: 255,   null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "name",              limit: 255
    t.string   "permalink",         limit: 255
    t.text     "description",       limit: 65535
    t.text     "short_description", limit: 65535
  end

  add_index "product_translations", ["locale"], name: "index_product_translations_on_locale", using: :btree
  add_index "product_translations", ["product_id"], name: "index_product_translations_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "sku",               limit: 255
    t.string   "permalink",         limit: 255
    t.text     "description",       limit: 65535
    t.text     "short_description", limit: 65535
    t.boolean  "active",                                                  default: true
    t.decimal  "weight",                          precision: 8, scale: 3, default: 0.0
    t.decimal  "price",                           precision: 8, scale: 2, default: 0.0
    t.decimal  "cost_price",                      precision: 8, scale: 2, default: 0.0
    t.integer  "grade_num",                                              limit: 4,default:0
    t.decimal  "grade_score",                                            precision: 8, scale: 2, default: 0.0
    t.integer  "great_num",                                              limit: 4,default:0
    t.integer  "product_category_id",                                    limit: 4
    t.integer  "tax_rate_id",                                            limit: 4
    t.integer  "parent_id",                                              limit: 4
    t.integer  "vendor_id",                                              limit: 4
    t.integer  "carriage_template_id",                                   limit:4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured",                                                default: false
    t.text     "in_the_box",                                              limit: 65535
    t.boolean  "stock_control",                                           default: true
    t.boolean  "default",                                                 default: false
  end

  create_table "carts", force: :cascade do |t|
    t.integer "num",           limit: 4, default: 0
    t.integer "product_id",    limit: 4
    t.integer "user_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", force: :cascade do |t|
    t.integer   "parent_id",    limit: 4
    t.string    "parent_type",  limit: 255
    t.integer   "user_id",      limit: 4
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

  add_index "products", ["parent_id"], name: "index_products_on_parent_id", using: :btree
  add_index "products", ["permalink"], name: "index_products_on_permalink", using: :btree
  add_index "products", ["sku"], name: "index_products_on_sku", using: :btree

  create_table "vendors", force: :cascade do |t|
    t.string   "name",                   limit: 255,   default: ""
    t.integer  "sold_num",               limit: 4,     default: 0
    t.integer  "grade_num",              limit:4 ,     default:0
    t.decimal  "grade_score",            precision:8,  scale:2,default:0.0
    t.decimal  "latitude",               precision: 8, scale: 2, default: 0.0
    t.decimal  "longitude",              precision: 8, scale: 2, default: 0.0
    t.integer  "user_id",                limit:4
    t.integer  "product_category_id",    limit: 4
    t.integer  "pid",                    limit:4
    t.integer  "cid",                    limit:4
    t.integer  "sid",                    limit:4
    t.string   "address",                limit:255,    default: ""
    t.string   "status",                 limit:255, default: 'confirming'
    t.text     "keywords",               limit: 65535
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "grade",force: :cascade do |t|
    t.decimal   "score",          precision:8,scale:2,default:0.0
    t.text      "content",       limit: 65535
    t.integer   "product_id",    limit:4
    t.integer   "user_id",       limit:4
  end

  create_table "settings", force: :cascade do |t|
    t.string  "key",        limit: 255
    t.string  "value",      limit: 255
    t.string  "value_type", limit: 255
  end

  add_index "settings", ["key"], name: "index_settings_on_key", using: :btree

  create_table "stock_level_adjustments", force: :cascade do |t|
    t.integer  "item_id",     limit: 4
    t.string   "item_type",   limit: 255
    t.string   "description", limit: 255
    t.integer  "adjustment",  limit: 4,   default: 0
    t.string   "parent_type", limit: 255
    t.integer  "parent_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stock_level_adjustments", ["item_id", "item_type"], name: "index_stock_level_adjustments_items", using: :btree
  add_index "stock_level_adjustments", ["parent_id", "parent_type"], name: "index_stock_level_adjustments_parent", using: :btree

  create_table "tax_rates", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.decimal  "rate",                       precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "country_ids",  limit: 65535
    t.string   "address_type", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",                     limit: 255
    t.string   "password",                  limit: 255
    t.string   "verify_password",           limit: 255
    t.string   "idcard",                    limit: 255,                  default: ""
    t.string   "email",                     limit: 255,                  default: ""
    t.string   "name",                      limit: 255,                  default: ""
    t.string   "real_name",                 limit: 255,                  default: ""
    t.integer  "sex",                       limit: 1,                    default: 0
    t.string   "channel",                   limit: 255
    t.string   "phone",                     limit: 255
    t.string   "birthday",                  limit: 255,                  default: ""
    t.string   "location",                  limit: 255,                  default: ""
    t.string   "slogan",                    limit: 255,                  default: ""
    t.string   "company",                   limit: 255,                  default: ""
    t.string   "job",                       limit: 255,                  default: ""
    t.string   "remember_token",            limit: 255
    t.string   "remember_token_last",            limit: 255
    t.datetime "remember_token_expires_at"
    t.string   "text_filter_id",            limit: 255,                  default: "1"
    t.string   "state",                     limit: 255,                  default: "active"
    t.datetime "last_connection"
    t.text     "settings",                  limit: 65535
    t.float    "latitude",                  limit: 24, default: 0
    t.float    "longitude",                 limit: 24, default: 0
    t.integer  "grade_num",                 limit:4, default:0
    t.decimal  "grade_score",               precision:8, scale:2, default:0.0
    t.integer  "profile_id",                limit:4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: :cascade do |t|
    t.string  "label",      limit: 255
    t.string  "nicename",   limit:255
    t.text    "modules",    limit: 65535
  end

  add_index "users", ["login"], name: "index_users_on_login", using: :btree

  create_table "banners", force: :cascade do |t|
    t.string   "name",        limit:255
    t.string   "link",        limit:255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visitor_logs", force: :cascade do |t|
    t.integer  "parent_id",   limit:4
    t.string   "parent_type", limit:255
    t.integer  "user_id",     limit:4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  # create_table "bank_cards", force: :cascade do |t|
  #   t.string  "no",         limit:255,  default:""
  #   t.string  "id_card",    limit:255,  default:""
  #   t.string  "user_name",  limit:255,  default:""
  #   t.string  "phone",      limit:255,  default:""
  # end

  create_table "funds", force: :cascade do |t|
    t.decimal  "avail",                 precision: 8, scale: 2, default: 0.0
    t.decimal  "congeal",                precision: 8, scale: 2, default: 0.0
    t.decimal  "credit",                precision: 8, scale: 2, default: 0.0
    t.integer  "user_id",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", force: :cascade do |t|
    t.integer   "vendor_id",            limit: 4
    t.integer   "product_category_id",  limit: 4
    t.integer   "num",                  limit: 4
    t.decimal   "value",                precision:8, scale:2, default:0.0
  end

  create_table "user_coupons", force: :cascade do |t|
    t.integer   "user_id",          limit: 4, null: false
    t.integer   "coupon_id",        limit: 4, null: false
  end

end
