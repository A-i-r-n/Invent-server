module Seller
  class CouponsController < Seller::BaseController
    before_filter { @active_nav = :coupons }
    before_filter { params[:id] && @coupon = Coupon.find(params[:id]) }

    # before_filter(only: [:create, :update, :destroy]) do
    #   if Shoppe.settings.demo_mode?
    #     fail Shoppe::Error, t('shoppe.users.demo_mode_error')
    #   end
    # end

    def index
      @coupons = Coupon.page(params[:page])
    end

    def new
      @coupon = Coupon.new
    end

    def create
      @coupon = Coupon.new(safe_params)
      @coupon.vendor = current_user.vendor
      if @coupon.save
        redirect_to [:seller,:coupons], flash: { notice: t('shoppe.users.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def show

    end

    def update
      if @coupon.update(safe_params)
        redirect_to [:edit,:seller, @vendro], flash: { notice: t('shoppe.users.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @coupon.destroy
      redirect_to [:seller,:coupons], flash: { notice: t('shoppe.users.destroy_notice') }
    end

    private
    def safe_params
      params[:coupon].permit(:coupon_type, :product_category_id, :amount, :exceed_val, :val)
    end
  end
end
