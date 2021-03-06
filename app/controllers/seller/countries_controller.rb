module Seller
  class CountriesController < Seller::BaseController
    before_filter { @active_nav = :countries }
    before_filter { params[:id] && @country = Country.find(params[:id]) }

    def index
      @countries = Country.ordered
    end

    def new
      @country = Country.new
    end

    def create
      @country = Country.new(safe_params)
      if @country.save
        redirect_to :countries, flash: { notice: t('shoppe.countries.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def update
      if @country.update(safe_params)
        redirect_to [:edit,:seller, @country], flash: { notice: t('shoppe.countries.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @country.destroy
      redirect_to :countries, flash: { notice: t('shoppe.countries.destroy_notice') }
    end

    private

    def safe_params
      params[:country].permit(:name, :code2, :code3, :continent, :tld, :currency, :eu_member)
    end
  end
end
