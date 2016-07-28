module Api
  class CollectionsController < Api::BaseController

    before_filter :login_required,except: [:login, :signup]

    def index
      @collections = Collection.where(user: current_user,parent_type: params[:parent_type]).page(params[:page])
    end

    def create
      @collection = Collection.new(safe_params)
      if @collection.save
        render 'collection'
      else
        render json: { code: 0,data:{ msg: "#{@collection.errors.full_messages[0]}" }}
      end
    end

    private
    def safe_params
      params[:collection].permit(:parent_id,:parent_type,:user_id)
    end

  end
end
