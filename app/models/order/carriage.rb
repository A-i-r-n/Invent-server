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

  def carriage_pricing
    order_items.inject(BigDecimal(0)) { |t,i | t += i.carriage_price  }
  end

  def carriage_price
    read_attribute(:carriage_price) || carriage_pricing || BigDecimal(0)
  end

end