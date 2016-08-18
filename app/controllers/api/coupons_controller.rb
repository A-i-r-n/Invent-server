module Api
  class CouponsController < Api::BaseController

    before_filter :login_required,only: [:take]
    before_filter {params[:id] && @coupon = Coupon.find(params[:id])}

    def index
      conditions = {}
      params[:product_category_id] && conditions.merge!({product_category_id: params[:product_category_id]})
      @coupons = Coupon.where(conditions).page(params[:page])
    end

    def take
      user = User.find(current_user)
      user.take_coupon(@coupon)
      render 'coupon'
    end
  end
end