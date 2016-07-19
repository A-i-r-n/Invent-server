class Order < ActiveRecord::Base

  before_save do
    if received? && ( read_attribute(:carriage_price).blank?)
      self.carriage_price = nil
      cache_carriage_pricing
    end
  end

  def cache_carriage_pricing
    write_attribute :carriage_price, carriage_pricing
  end

  def city_id
    @cid ||= Address.find(address_id).cid
  end

  def ordered_products
    order_items.map { |item| item.ordered_item  }
  end

  def carriage_pricing
    price_total = 0
    ordered_products.each { |product|
      next if product.nil?
      carriage_template = product.carriage_template
      next if carriage_template.nil?
      template_prices = carriage_template.carriage_template_prices
      template_prices.each { |price|
        contain = price.express_areas_ids.split(',').include?("#{city_id}")
        price_total += (price.postage + (total_weight - price.start) * (price.postageplus/price.plus)) if contain
      }
    }
    price_total
  end

  def carriage_price
    read_attribute(:carriage_price) || carriage_pricing || BigDecimal(0)
  end



end

