class Order < ActiveRecord::Base
  belongs_to :coupon

  def preferential_fee
    coupon && (total_fee > coupon.exceed_val) && coupon.val || BigDecimal(0)
  end

end
