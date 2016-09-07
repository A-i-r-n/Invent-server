module Api
  class UnboxingsController < Api::BaseController

    # before_filter :login_required,except: [:login, :signup]

    before_filter {params[:id] && @unboxing = Unboxing.find(params[:id])}

    def index
      @unboxings = Unboxing.page(params[:page])
    end

    def show

    end

    def create
      @unboxing = Unboxing.new(safe_params)
      @unboxing.user = current_user
      if @unboxing.save
        render 'unboxing'
      else
        render_error(e(@unboxing))
      end
    end

    private
    def safe_params
      params[:unboxing].permit(:description,:campaign_record_id)
    end

  end
end