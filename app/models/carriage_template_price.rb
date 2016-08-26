  class CarriageTemplatePrice < ActiveRecord::Base
    # # Set the table name
    # # self.table_name = 'shoppe_delivery_service_prices'
    #
    # include AssociatedCountries
    #
    # # The delivery service which this price belongs to
    belongs_to :carriage_template, class_name: 'CarriageTemplate'

    # Validations
    validates :key, presence: true

    #
    # # The tax rate which should be applied
    # belongs_to :tax_rate, class_name: 'TaxRate'
    #
    # # Validations
    # validates :code, presence: true
    # validates :price, numericality: true
    # validates :cost_price, numericality: true, allow_blank: true
    # validates :min_weight, numericality: true
    # validates :max_weight, numericality: true
    #
    # # All prices ordered by their price ascending
    # scope :ordered, -> { order(price: :asc) }
    #
    # # All prices which are suitable for the weight passed.
    # #
    # # @param weight [BigDecimal] the weight of the order
    # scope :for_weight, -> (weight) { where('min_weight <= ? AND max_weight >= ?', weight, weight) }

    # Create/update attributes for a product based on the provided hash of
    # keys & values.
    #
    # @param array [Array]
    def self.update_from_array(array,carriage_template)
      prices = carriage_template.carriage_template_prices
      existing_keys = prices.pluck(:key)
      index = 0
      array.each do |hash|
        next if hash['key'].blank?
        index += 1
        params = hash
                     # .merge(searchable: hash['searchable'].to_s == '1',
                     #        public: hash['public'].to_s == '1',
                     #        position: index)
        if existing_attr = prices.where(key: hash['key']).first
          if hash['key'].blank?
            existing_attr.destroy
            index -= 1
          else
            existing_attr.update_attributes(params)
          end
        else
          attribute = create(params)
        end
      end
      # where(key: existing_keys - array.map { |h| h['key'] }).delete_all
      true
    end

  end
