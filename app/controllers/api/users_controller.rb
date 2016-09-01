module Api
  class UsersController < Api::BaseController

    before_action :login_required

    def unread_count

    end

    def fund
      @fund = current_fund
      if request.post?
        @fund.recharge(params[:money].to_f)
      end
    end

    def messages
      @messages = Message.push_order(current_user).page(params[:page])
    end

    def coupons
      @coupons =  @coupons = Coupon.joins(:users)
                                 .where( user_coupons: { user_id: current_user.id },vendor_id: params[:vendor_id])
                                 .page(params[:page])
    end

    def coupon_count
      @count = UserCoupon.where( user: current_user).count
      render_json_success_message(@count)
    end

    private
    def current_fund
      Fund.find_or_create_by(user: current_user)
    end

    def fund_params
      params[:fund]
    end

    def all_coupons

    end

  end
end