module Seller
  class AgglomerationsController < Seller::BaseController
    before_filter { @active_nav = :agglomerations }
    before_filter { params[:id] && @agglomeration = Agglomeration.find(params[:id]) }

    # before_filter(only: [:create, :update, :destroy]) do
    #   if Shoppe.settings.demo_mode?
    #     fail Shoppe::Error, t('shoppe.users.demo_mode_error')
    #   end
    # end

    def index
      @agglomerations = Agglomeration.page(params[:page])
    end

    def new
      @agglomeration = Agglomeration.new
    end

    def create
      @agglomeration = Agglomeration.new(safe_params)
      @agglomeration.vendor = current_user.vendor
      if @agglomeration.save
        redirect_to [:seller,:agglomerations], flash: { notice: t('shoppe.users.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def show

    end

    def update
      if @agglomeration.update(safe_params)
        redirect_to [:edit,:seller, @agglomeration], flash: { notice: t('shoppe.users.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @agglomeration.destroy
      redirect_to [:seller,:agglomerations], flash: { notice: t('shoppe.users.destroy_notice') }
    end

    private
    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:agglomeration].permit(:name, :price,:max_participants,:description,:status,:category_id,:end_time,
                                    attachments: [default_image: file_params, data_sheet: file_params, extra: file_params]

      )
    end
  end
end
