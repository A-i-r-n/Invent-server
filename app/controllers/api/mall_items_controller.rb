module Api
  class MallItemsController < Api::BaseController

    # before_filter :login_required,except: [:login, :signup]

    before_filter {params[:id] && @mall_item = MallItem.find(params[:id])}

    def index
      @mall_items = MallItem.page(params[:page])
    end

    def show

    end

    def images
      @attachments = @mall_item.attachments
    end

    def detail
      render layout: 'api'
    end

    def order
      @mall_item_order = MallItemOrder.new
      @mall_item_order.user = current_user
      @mall_item_order.campaign = @mall_item
      if ! @mall_item_order.save
        render_json_error_message(e_msg(@mall_item_order))
      end
    end

    def records
      @mall_item && (conditions ||= {}) && conditions.merge!({campaign: @mall_item})
      @mall_item_records = MallItemRecord.where(conditions).order(created_at: :desc).page(params[:page])
    end

  end
end