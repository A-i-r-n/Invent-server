module Api
  class SharesController < Api::BaseController

    before_filter :login_required,except: [:login, :signup]

    def index
      @shares = Share.where(user:current_user,parent_type: 'Product').page(params[:page])
    end

    def create
      @share = Share.new(safe_params)
      @share.user = current_user
      if @share.save
        render 'share'
      else
        render_error(e(@share))
      end
    end

    private
    def safe_params
      params[:share].permit(
          :parent_id,
          :parent_type
      )
    end

  end
end