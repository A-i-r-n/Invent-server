class ProductAttribution < ActiveRecord::Base
  # self.table_name = 'shoppe_product_categorizations'

  # Links back
  belongs_to :product, class_name: 'Product'
  belongs_to :product_attribute, class_name: 'ProductAttribute'

  # Validations
  validates_presence_of :product, :product_attribute
end
