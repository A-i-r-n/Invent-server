module Api
  class CollectionsController < Api::BaseController

    before_filter :login_required,except: [:login, :signup]

    def index
      @collections = Collection.where(user: current_user,parent_type: params[:parent_type]).page(params[:page])
    end

    def create
      @collection = Collection.find_or_create_by(safe_params)
      @collection.user = current_user
      if @collection.save
        render 'collection'
      else
        render_json_error_message(e_msg(@collection))
      end
    end

    private
    def safe_params
      params[:collection].permit(:parent_id,:parent_type,:user_id)
    end

  end
end
