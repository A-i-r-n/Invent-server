module Admin
  class BannersController < Admin::BaseController
    before_filter { @active_nav = :banners }
    before_filter { params[:id] && @banner = Banner.find(params[:id]) }

    def index
      @banners = Banner.page(params[:page])
    end

    def new
      @banner = Banner.new
    end

    def create
      @banner = Banner.new(safe_params)
      if @banner.save
        redirect_to [:admin,:banners], flash: { notice: t('shoppe.products.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def update
      if @banner.update(safe_params)
        redirect_to [:edit,:admin, @banner], flash: { notice: t('shoppe.products.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @banner.destroy
      redirect_to [:admin,:banners], flash: { notice: t('shoppe.products.destroy_notice') }
    end

    private

    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:product].permit(:name,:link, attachments: [default_image: file_params, data_sheet: file_params, extra: file_params])
    end
  end
end
