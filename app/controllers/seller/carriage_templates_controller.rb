module Seller
  class CarriageTemplatesController < Seller::BaseController
    before_filter { @active_nav = :carriage_templates }
    before_filter { params[:id] && @carriage_template = CarriageTemplate.find(params[:id]) }

    def index
      @carriage_templates = CarriageTemplate.all
    end

    def new
      @carriage_template = CarriageTemplate.new
    end

    def create
      @carriage_template = CarriageTemplate.new(safe_params)
      if @carriage_template.save
        redirect_to [:seller,:carriage_templates], flash: { notice: t('shoppe.delivery_services.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def update
      if @carriage_template.update(safe_params)
        redirect_to [:edit,:seller, @carriage_template], flash: { notice: t('shoppe.delivery_services.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @carriage_template.destroy
      redirect_to [:seller,:carriage_templates], flash: { notice: t('shoppe.delivery_services.destroy_notice') }
    end

    private

    def safe_params
      params[:carriage_templates].permit(:name, carriage_templates_array: [:name,:express_areas])
    end
  end
end
