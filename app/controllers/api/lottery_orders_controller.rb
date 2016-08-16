module Api
  class LotteryOrdersController < Api::BaseController

    before_filter :login_required,except: [:login, :signup]

    def create
      @lottery_order = LotteryOrder.new(safe_params)
      @lottery_order.user = current_user
      if @lottery_order.save
        render 'lottery_order'
      else
        render_json_error_message(e_msg(@lottery_order))
      end
    end

    private
    def safe_params
      params[:lotter_order].permit(:lottery_id)
    end

  end
end