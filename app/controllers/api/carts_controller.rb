module Api
  class CartsController < Api::BaseController

    # before_filter :login_required,except: [:login, :signup]

    before_filter { params[:id] && @cart = Cart.find(params[:id]) }

    def index
      @carts = Cart.where(user: current_user)# .all.group_by(&:product_vendor)
      # render json: @carts
    end

    def create
      @cart = Cart.find_or_create_by(product_id: safe_params[:product_id])
      @cart.num += 1
      @cart.user = current_user
      if @cart.save
        render 'cart'
      else
        render json: {code: 1, data: {msg: "#{@cart.errors.full_messages[0]}"}}
      end
    end

    def update
      if @cart.update(safe_params)
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