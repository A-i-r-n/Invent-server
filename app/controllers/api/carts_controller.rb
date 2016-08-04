module Api
  class CartsController < Api::BaseController

    before_filter :login_required,except: [:login, :signup]

    before_filter { params[:id] && @cart = Cart.find(params[:id]) }

    def index
      @carts = Cart.where(user: current_user).group_by(&:product_vendor)
    end

    def create
      @cart = Cart.find_or_create_by(product_id: safe_params[:product_id])
      @cart.num += 1
      @cart.user = current_user
      if @cart.save
        render 'cart'
      else
        render_json_error_message(e_msg(@cart))
      end
    end

    def update
      if @cart.update(safe_params)
        render 'cart'
      else
        render_json_error_message(e_msg(@cart))
      end
    end

    private
    def safe_params
      params[:cart].permit(:num,:product_id)
    end

  end
end