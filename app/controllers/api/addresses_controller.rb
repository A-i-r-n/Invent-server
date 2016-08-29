module Api
  class AddressesController < Api::BaseController

    before_filter :login_required,except: [:login, :signup]

    before_filter {params[:id] && @address = Address.find(params[:id])}

    def index
      @addresses = Address.where(customer: current_user.customer).page(params[:page]||=1)
    end

    def default
      @address = Address.where(customer: current_user.customer).default.first
      if @address.blank?
        render json: {code: 1001,data: "no address"}
      else
        render 'address'
      end

    end

    def create
      @address = Address.new(safe_params)
      @address.customer = current_user.customer
      if @address.save
        render 'address'
      else
        render_error(e_msg(@address))
      end
    end

    def destroy
      @address.destroy
      render_json_success_message("destroy success")
    end

    private
    def safe_params
      params[:address].permit(:name,:phone,:address,:address_type,:pid,:cid,:sid)
    end

  end
end