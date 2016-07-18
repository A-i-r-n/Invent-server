class Order < ActiveRecord::Base

  def city_id
    Address.find(address_id).cid
  end

  def ordered_products
    order_items.map { |item| item.ordered_item  }
  end

  def carriage_price
    price_total = 0
    ordered_products.each { |product|
      template_prices = product.carriage_template.carriage_template_prices
      template_prices.each { |price|
        contain = price.express_areas_ids.split(',').include?("#{city_id}")
        price_total += (price.postage + (total_weight - price.start) * (price.postageplus/price.plus)) if contain
      }
    }
    price_total
  end

end

