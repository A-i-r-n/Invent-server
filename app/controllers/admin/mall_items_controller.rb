module Admin
  class MallItemsController < Admin::BaseController
    before_filter { @active_nav = :@mall_items }
    before_filter { params[:id] && @mall_item = MallItem.find(params[:id]) }

    def index
      @mall_items = MallItem.page(params[:page])
    end

    def new
      @mall_item = MallItem.new
    end

    def create
      @mall_item = MallItem.new(safe_params)
      if @mall_item.save
        redirect_to [:admin,:mall_items], flash: { notice: t('shoppe.products.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def update
      if @mall_item.update(safe_params)
        redirect_to [:edit,:admin, @mall_item], flash: { notice: t('shoppe.products.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @mall_item.destroy
      redirect_to [:admin,:mall_items], flash: { notice: t('shoppe.products.destroy_notice') }
    end

    private

    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:product].permit(:name,:type,:price,:periods, :max_periods, :participants, :max_participants, :description, :status, attachments: [default_image: file_params, data_sheet: file_params, extra: file_params])
    end
  end
end
