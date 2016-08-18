module Api
  class LotteryRecordsController < Api::BaseController

    # before_filter :login_required,except: [:login, :signup]

    before_filter {params[:id] && @lottery = Lottery.find(params[:id])}

    def index
      conditions = {}
      params[:lottery_id] && conditions.merge!({lottery_id: params[:lottery_id]})
      @lottery_records = LotteryRecord.where(conditions).order(created_at: :desc).page(params[:page])
      if ! params[:limit].blank?
        @lottery_records = @lottery_records.limit(params[:limit])
      end
    end

  end
end