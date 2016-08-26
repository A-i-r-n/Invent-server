require 'roo'
require 'globalize'

class Product < ActiveRecord::Base

  YYG_VAL = 'yyg'
  YYG_TEXT = '一元购'
  PRODUCT_TYPE = [[YYG_TEXT , YYG_VAL]].freeze
  # self.table_name = 'shoppe_products'

  # Add dependencies for products
  require_dependency 'product/product_attributes'
  require_dependency 'product/variants'

  belongs_to :vendor

  # Attachments for this product
  has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Attachment'

  has_many :grades, as: :item, dependent: :destroy, autosave: true, class_name: 'Grade'

  belongs_to :carriage_template

  # The product's categorizations
  #
  # @return [Shoppe::ProductCategorization]
  has_many :product_categorizations, dependent: :destroy, class_name: 'ProductCategorization', inverse_of: :product
  # The product's categories
  #
  # @return [Shoppe::ProductCategory]
  has_many :product_categories, class_name: 'ProductCategory', through: :product_categorizations

  belongs_to :product_category

  # The product's tax rate
  #
  # @return [Shoppe::TaxRate]
  belongs_to :tax_rate, class_name: 'TaxRate'

  # Ordered items which are associated with this product
  has_many :order_items, dependent: :restrict_with_exception, class_name: 'OrderItem', as: :ordered_item

  # Orders which have ordered this product
  has_many :orders, through: :order_items, class_name: 'Order'

  # Stock level adjustments for this product
  has_many :stock_level_adjustments, dependent: :destroy, class_name: 'StockLevelAdjustment', as: :item

  # Validations
  with_options if: proc { |p| p.parent.nil? } do |product|
    product.validate :has_at_least_one_product_category
    product.validates :description, presence: true
    product.validates :short_description, presence: true
  end

  with_options if: proc {|p| p.parent.present? } do |product|
    product.validate :has_included_attr
    product.validate :has_attr
  end

  validates :name, presence: true
  validates :permalink, presence: true, uniqueness: true, permalink: true
  validates :sku, presence: true
  validates :weight, numericality: true
  validates :price, numericality: true
  validates :cost_price, numericality: true, allow_blank: true

  # Before validation, set the permalink if we don't already have one
  before_validation { self.permalink = PinYin.permlink("#{name}") if permalink.blank? && name.is_a?(String) } #.parameterize

  # All active products
  scope :active, -> { where(active: true) }

  # All featured products
  scope :featured, -> { where(featured: true) }

  # Localisations
  translates :name, :permalink, :description, :short_description
  scope :ordered, -> { includes(:translations).order(:name) }

  scope :root,->(vendor){
    where(vendor: vendor)
  }

  scope :admin ,->{
    where(vendor: nil,parent: nil)
  }

  def attachments=(attrs)
    if attrs['default_image']['file'].present? then attachments.build(attrs['default_image']) end
    if attrs['data_sheet']['file'].present? then attachments.build(attrs['data_sheet']) end

    if attrs['extra']['file'].present? then attrs['extra']['file'].each { |attr| attachments.build(file: attr, parent_id: attrs['extra']['parent_id'], parent_type: attrs['extra']['parent_type']) } end
  end

  # Return the name of the product
  #
  # @return [String]
  def full_name
    parent ? "#{parent.name} (#{name})" : name
  end

  def vendor_id
    read_attribute(:vendor_id) || parent && parent.vendor_id || Integer(0)
  end

  # Is this product orderable?
  #
  # @return [Boolean]
  def orderable?
    return false unless active?
    return false if has_variants?
    true
  end

  # The price for the product
  #
  # @return [BigDecimal]
  def price
    # self.default_variant ? self.default_variant.price : read_attribute(:price)
    default_variant ? default_variant.price : read_attribute(:price)
  end

  def product_vendor
    self.vendor || parent.vendor
  end

  # Is this product currently in stock?
  #
  # @return [Boolean]
  def in_stock?
    default_variant ? default_variant.in_stock? : (stock_control? ? stock > 0 : true)
  end

  # Return the total number of items currently in stock
  #
  # @return [Fixnum]
  def stock
    stock_level_adjustments.sum(:adjustment)
  end

  # Return the first product category
  #
  # @return [Shoppe::ProductCategory]
  def product_category
    product_categories.first
  rescue
    nil
  end

  # Return attachment for the default_image role
  #
  # @return [String]
  def default_image
    attachments.for('default_image')
  end

  # Set attachment for the default_image role
  def default_image_file=(file)
    attachments.build(file: file, role: 'default_image')
  end

  # Return attachment for the data_sheet role
  #
  # @return [String]
  def data_sheet
    attachments.for('data_sheet')
  end

  # Search for products which include the given attributes and return an active record
  # scope of these products. Chainable with other scopes and with_attributes methods.
  # For example:
  #
  #   Shoppe::Product.active.with_attribute('Manufacturer', 'Apple').with_attribute('Model', ['Macbook', 'iPhone'])
  #
  # @return [Enumerable]
  def self.with_attributes(key, values)
    product_ids = ProductAttribute.searchable.where(key: key, value: values).pluck(:product_id).uniq
    where(id: product_ids)
  end

  # Imports products from a spreadsheet file
  # Example:
  #
  #   Shoppe:Product.import("path/to/file.csv")
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    spreadsheet.default_sheet = spreadsheet.sheets.first
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      # Don't import products where the name is blank
      next if row['name'].nil?
      if product = where(name: row['name']).take
        # Dont import products with the same name but update quantities
        qty = row['qty'].to_i
        if qty > 0
          product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
        end
      else
        product = new
        product.name = row['name']
        product.sku = row['sku']
        product.description = row['description']
        product.short_description = row['short_description']
        product.weight = row['weight']
        product.price = row['price'].nil? ? 0 : row['price']
        product.permalink = row['permalink']

        product.product_categories << begin
          ProductCategory.find_or_initialize_by(name: row['category_name'])
        end

        product.save!

        qty = row['qty'].to_i
        if qty > 0
          product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
        end
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when '.csv' then Roo::CSV.new(file.path)
      when '.xls' then Roo::Excel.new(file.path)
      when '.xlsx' then Roo::Excelx.new(file.path)
      else fail I18n.t('shoppe.imports.errors.unknown_format', filename: File.original_filename)
    end
  end

  def carriage_templation
    carriage_template || (parent && parent.carriage_templation)
  end

  def carriage_price(city_id,quantity = 1)
    price_total = 0
    if carriage_templation
      template_prices = carriage_templation.carriage_template_prices
      template_price = template_prices.find_all{ |p| p.express_areas_ids.split(',').include?("#{city_id}") }.first
      price_total += (template_price.postage + (weight * quantity - template_price.start) * (template_price.postageplus/template_price.plus)) if template_price
    end
    price_total
  end

  def judge_for(grade)
    self.grade_num += 1
    self.grade_score += grade.score
    atts = grade.attributes
    atts[:id] = nil
    atts[:parent_id] = grade.id
    grades.create(atts)
    save
    parent.try(:judge_for,grade) if parent
  end

  private

  # Validates

  def has_at_least_one_product_category
    errors.add(:base, 'must add at least one product category') if product_categories.blank?
  end

  def has_included_attr
    filter_variants = self.parent.variants.find_all{|product| product.id != self.id }
    included = false
    filter_variants.map { |product|
      (product.product_attribute_ids - self.product_attribute_ids).empty? ||
          (self.product_attribute_ids - product.product_attribute_ids).empty?
    }.each { |has|
      included = true
      break if has
      included = false
    }
    errors.add(:base,"属性选择错误,可能商品属性重叠!!!") if included
  end

  def has_attr
    has = self.parent.product_attributes.map(&:key).uniq - self.product_attributes.map(&:key)
    errors.add(:base,"请将属性选择完整!!!") if ! has.empty?
  end


end
