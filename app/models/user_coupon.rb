class UserCoupon < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :coupon, class_name: 'Coupon'

  validates_presence_of :user, :coupon
end
