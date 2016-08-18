class Coupon < ActiveRecord::Base
    belongs_to :vendor
    belongs_to :product_category
    has_many :user_coupons, dependent: :restrict_with_exception, class_name: 'UserCoupon', inverse_of: :coupon
    has_many :users, class_name: 'User', through: :user_coupons

end