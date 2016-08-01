module Api
  class OrdersController < Api::BaseController

    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def index
      conditions = params[:status] != 'all' ? {status: params[:status]} : {}
      @query = Order.ordered.where(conditions).includes(order_items: :ordered_item).page(params[:page]).search(params[:q])
      @orders = @query.result
    end

    def create
      Order.transaction do
        @orders = []
        safe_params[:orders].map do |key,order_safe_params|

          order_params = order_safe_params[:order]

          @order = Order.new(order_params)
          @order.status = 'confirming'

          if !order_params['customer_id'].blank?
            @customer = Customer.find safe_params[:customer_id]
            @order.first_name = @customer.first_name
            @order.last_name = @customer.last_name
            @order.company = @customer.company
            @order.email_address = @customer.email
            @order.phone_number = @customer.phone
            if @customer.addresses.billing.present?
              billing = @customer.addresses.billing.first
              @order.billing_address1 = billing.address1
              @order.billing_address2 = billing.address2
              @order.billing_address3 = billing.address3
              @order.billing_address4 = billing.address4
              @order.billing_postcode = billing.postcode
              @order.billing_country_id = billing.country_id
            end
            if @customer.addresses.delivery.present?
              delivery = @customer.addresses.delivery.first
              @order.delivery_address1 = delivery.address1
              @order.delivery_address2 = delivery.address2
              @order.delivery_address3 = delivery.address3
              @order.delivery_address4 = delivery.address4
              @order.delivery_postcode = delivery.postcode
              @order.delivery_country_id = delivery.country_id
            end
          end

          @orders << @order

          case params[:method]
            when 'edit'
            when 'submit'
              if @order.save
                @order.confirm!
              # else
              #   return(render json: {code: 1, data: {msg: "#{@order.errors.full_messages[0]}"}})
              end
          end
        end
        # rescue Shoppe::Errors::InsufficientStockToFulfil => e
        #   flash.now[:alert] = t('shoppe.orders.insufficient_stock_order', out_of_stock_items: e.out_of_stock_items.map { |t| t.ordered_item.full_name }.to_sentence)
        #   render action: 'new'
        render 'order'
      end
    end

    private
    def safe_params
      params.permit(
          orders: [
              order: [
                  :customer_id,
                  :first_name, :last_name, :company,
                  :billing_address1, :billing_address2, :billing_address3, :billing_address4, :billing_postcode, :billing_country_id,
                  :separate_delivery_address,
                  :delivery_name, :delivery_address1, :delivery_address2, :delivery_address3, :delivery_address4, :delivery_postcode, :delivery_country_id,
                  :delivery_price, :delivery_service_id, :delivery_tax_amount,
                  :email_address, :phone_number,
                  :notes,
                  :address_id,
                  order_items_attributes: [:ordered_item_id, :ordered_item_type, :quantity, :unit_price, :tax_amount, :id, :weight]
              ]
          ]
      )
    end
  end
end