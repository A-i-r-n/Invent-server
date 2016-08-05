module Admin
class VendorsController < Admin::BaseController
    before_filter { @active_nav = :vendors }
    before_filter { params[:id] && @vendor = Vendor.find(params[:id]) }
    before_filter(only: [:create, :update, :destroy]) do
      if Shoppe.settings.demo_mode?
        fail Shoppe::Error, t('shoppe.users.demo_mode_error')
      end
    end

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
      if @user.update(safe_params)
        redirect_to [:edit,:admin, @user], flash: { notice: t('shoppe.users.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      fail Shoppe::Error, t('shoppe.users.self_remove_error') if @user == current_user
      @user.destroy
      redirect_to [:admin,:users], flash: { notice: t('shoppe.users.destroy_notice') }
    end

    private

    def safe_params
      params[:vendor].permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
    end
  end
end
