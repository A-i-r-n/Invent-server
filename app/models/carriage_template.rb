  class CarriageTemplate < ActiveRecord::Base

    has_many :carriage_template_prices, -> { order(:key) }, class_name: 'CarriageTemplatePrice'

    # Used for setting an array of product attributes which will be updated. Usually
    # received from a web browser.
    attr_accessor :carriage_template_prices_array

    # After saving automatically try to update the product attributes based on the
    # the contents of the product_attributes_array array.
    after_save do
      if carriage_template_prices_array.is_a?(Array)
        carriage_template_prices.update_from_array(carriage_template_prices_array)
      end
    end

  end
