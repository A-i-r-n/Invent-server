module Api
  class LotteriesController < Api::BaseController

    # before_filter :login_required,except: [:login, :signup]

    before_filter {params[:id] && @lottery = Lottery.find(params[:id])}

    def index
      @lotteries = Lottery.active.page(params[:page])
    end

    def show

    end

    def images
      @attachments = @lottery.attachments
    end

    def detail
      render layout: 'api'
    end

    def order
      @lottery_order = LotteryOrder.new
      @lottery_order.user = current_user
      @lottery_order.campaign = @lottery
      if ! @lottery_order.save
        render_json_error_message(e_msg(@lottery_order))
      end
    end

    def records
      @lottery && (conditions ||= {}) && conditions.merge!({campaign: @lottery})
      @lottery_records = LotteryRecord.where(conditions).order(created_at: :desc).page(params[:page])
      if ! params[:limit].blank?
        @lottery_records = @lottery_records.limit(params[:limit])
      end
    end

    def record_count
      @count = LotteryRecord.count
      render_success(@count)
    end

    # private
    # def safe_params
    #   params[:lotter_order].permit(:lottery_id)
    # end

  end
end