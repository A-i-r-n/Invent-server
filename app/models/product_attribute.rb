class ProductAttribute < ActiveRecord::Base
  # self.table_name = 'shoppe_product_attributes'

  # Validations
  validates :key, presence: true#,uniqueness: true


  # The product's categorizations
  #
  # @return [Shoppe::ProductCategorization]
  has_many :product_attributions, dependent: :restrict_with_exception, class_name: 'ProductAttribution', inverse_of: :product_attribute

  #
  # @return [Shoppe::ProductCategory]
  has_many :products, class_name: 'Product', through: :product_attributions

  # if fail ,go back
  # # The associated product
  # #
  # # @return [Shoppe::Product]
  # belongs_to :product, class_name: 'Product'

  # All attributes which are searchable
  scope :searchable, -> { where(searchable: true) }

  # All attributes which are public
  scope :publicly_accessible, -> { where(public: true) }


  scope :root,->(product_id){
    where(product_id: product_id)
  }

  # Return the available options as a hash
  #
  # @return [Hash]
  def self.grouped_hash
    all.group_by(&:key).inject({}) do |h, (key, attributes)|
      h[key] = attributes.map(&:value).uniq
      h
    end
  end

  def full_name
    "#{key} #{value}"
  end

  # Create/update attributes for a product based on the provided hash of
  # keys & values.
  #
  # @param array [Array]
  def self.update_from_array(array,product)
    existing_keys = product.product_attributes.pluck(:key)
    existing_values = product.product_attributes.pluck(:value)
    index = 0
    array.each do |hash|
      next if hash['key'].blank?
      index += 1
      params = hash.merge(searchable: hash['searchable'].to_s == '1',
                          public: hash['public'].to_s == '1',
                          position: index)

      if existing_attr = product.product_attributes.where(key: hash['key'],value: hash['value']).first
        if hash['value'].blank?
          existing_attr.destroy
          index -= 1
        else
          existing_attr.update_attributes(params)
        end
      else
        attribute = product.product_attributes.create(params)
      end
    end
    product.product_attributes.where(value: existing_values - array.map { |h| h['value'] }).delete_all #key: existing_keys - array.map { |h| h['key'] },
    true
  end

  def self.public
    ActiveSupport::Deprecation.warn('The use of ProductAttribute.public is deprecated. use ProductAttribute.publicly_accessible.')
    publicly_accessible
  end
end
