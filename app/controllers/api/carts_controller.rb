module Api
  class CartsController < Api::BaseController

    before_filter :login_required,except: [:login, :signup]

    def index
      @carts = Cart.where(user: current_user)
    end

    def create
      @cart = Cart.new(safe_params)
      @cart.user = current_user

      if @cart.save
        render 'cart'
      else
        render json: {code: 1, data: {msg: "#{@cart.errors.full_messages[0]}"}}
      end
    end

    private
    def safe_params
      params[:cart].permit(:num,:product_id)
    end

  end
end