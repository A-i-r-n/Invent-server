module Seller
  class DeliveryServicesController < Seller::BaseController
    before_filter { @active_nav = :delivery_services }
    before_filter { params[:id] && @delivery_service = DeliveryService.find(params[:id]) }

    def index
      @delivery_services = DeliveryService.all
    end

    def new
      @delivery_service = DeliveryService.new
    end

    def create
      @delivery_service = DeliveryService.new(safe_params)
      if @delivery_service.save
        redirect_to [:seller,:delivery_services], flash: { notice: t('shoppe.delivery_services.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def update
      if @delivery_service.update(safe_params)
        redirect_to [:edit,:seller, @delivery_service], flash: { notice: t('shoppe.delivery_services.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @delivery_service.destroy
      redirect_to :delivery_services, flash: { notice: t('shoppe.delivery_services.destroy_notice') }
    end

    private

    def safe_params
      params[:delivery_service].permit(:name, :code, :active, :default, :courier, :tracking_url)
    end
  end
end
