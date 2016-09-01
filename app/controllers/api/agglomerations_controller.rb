module Api
  class AgglomerationsController < Api::BaseController

    # before_filter :login_required,except: [:login, :signup]

    before_filter {params[:id] && @agglomeration = Agglomeration.find(params[:id])}

    def index
      conditions = {}
      params[:vendor_id] && conditions.merge!({vendor_id: params[:vendor_id]})
      @agglomerations = Agglomeration.active.where(conditions).page(params[:page])
    end

    def show

    end

    def images
      @attachments = @agglomeration.attachments
    end

    def detail
      render layout: 'api'
    end

    def order
      @agglomeration_order = AgglomerationOrder.new
      @agglomeration_order.user = current_user
      @agglomeration_order.campaign = @agglomeration
      if ! @agglomeration_order.save
        render_json_error_message(e_msg(@lottery_order))
      end
    end

    def records
      @agglomeration && (conditions ||= {}) && conditions.merge!({campaign: @agglomeration})
      @agglomeration_records = AgglomerationRecord.where(conditions).order(created_at: :desc).page(params[:page])
      if ! params[:limit].blank?
        @agglomeration_records = @agglomeration_records.limit(params[:limit])
      end
    end

    # private
    # def safe_params
    #   params[:lotter_order].permit(:lottery_id)
    # end

  end
end