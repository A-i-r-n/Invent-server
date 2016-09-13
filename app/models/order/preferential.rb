class Order < ActiveRecord::Base
  belongs_to :coupon

  def preferential_fee
    coupon && (
    case  coupon.coupon_type
      when 'full'
        (total_fee > coupon.exceed_val) && coupon.val
      when 'discount'
        total_fee * ( 1 - coupon.val/10.0)
    end
    ) || BigDecimal(0)
  end

end
