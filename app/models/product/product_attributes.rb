class Product < ActiveRecord::Base


  has_many :product_attributions, dependent: :destroy, class_name: 'ProductAttribution', inverse_of: :product
  #
  # @return [Shoppe::ProductCategory]
  has_many :product_attributes, class_name: 'ProductAttribute', through: :product_attributions # -> { order(:position) }


  # if fail,go back
  # # Product attributes for this product
  # has_many :product_attributes, -> { order(:position) }, class_name: 'ProductAttribute'

  # Used for setting an array of product attributes which will be updated. Usually
  # received from a web browser.
  attr_accessor :product_attributes_array

  # After saving automatically try to update the product attributes based on the
  # the contents of the product_attributes_array array.
  after_save do
    if product_attributes_array && product_attributes_array.is_a?(Array)
      product_attributes.update_from_array(product_attributes_array)
    end
  end
end