module Admin
class VendorsController < Admin::BaseController
    before_filter { @active_nav = :vendors }
    before_filter { params[:id] && @vendor = Vendor.find(params[:id]) }

    # before_filter(only: [:create, :update, :destroy]) do
    #   if Shoppe.settings.demo_mode?
    #     fail Shoppe::Error, t('shoppe.users.demo_mode_error')
    #   end
    # end

    def index
      @vendors = Vendor.received.page(params[:page])
    end

    def new
      @user = User.new
    end

    def create
      @vendor = Vendor.new(safe_params)
      if @user.save
        redirect_to [:admin,:users], flash: { notice: t('shoppe.users.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def show

    end

    def update
      if @vendor.update(safe_params)
        redirect_to [:edit,:admin, @vendro], flash: { notice: t('shoppe.users.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @vendor.destroy
      redirect_to [:admin,:vendorsa], flash: { notice: t('shoppe.users.destroy_notice') }
    end

    def accept
      @vendor.accept
      redirect_to [:admin,@vendor], flash: { notice: t('shoppe.orders.accept_notice') }
    rescue Shoppe::Errors::PaymentDeclined => e
      redirect_to [:admin,@vendor], flash: { alert: e.message }
    end

    def reject
      @vendor.reject
      redirect_to [:admin,@vendor], flash: { notice: t('shoppe.orders.reject_notice') }
    rescue Shoppe::Errors::PaymentDeclined => e
      redirect_to [:admin,@vendor], flash: { alert: e.message }
    end

    private

    def safe_params
      params[:vendor].permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
    end
  end
end
