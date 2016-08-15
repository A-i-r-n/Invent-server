module Api
  class UsersController < Api::BaseController

    before_action :login_required

    def addresses
      @addresses = Address.where(customer: current_user.customer).page(params[:page]||=1)
    end

    def address
      @address = Address.where(customer: current_user.customer).default.first
    end

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

    private
    def current_fund
      Fund.find_or_create_by(user: current_user)
    end

    def fund_params
      params[:fund]
    end

  end
end