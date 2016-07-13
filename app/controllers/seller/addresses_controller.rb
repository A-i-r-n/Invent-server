module Seller
  class AddressesController < Seller::BaseController
    before_filter { @active_nav = :customers }
    before_filter { params[:customer_id] && @customer = Customer.find(params[:customer_id]) }
    before_filter { params[:id] && @address = @customer.addresses.find(params[:id]) }

    def new
      @address = Address.new
    end

    def edit
    end

    def create

      Address.transaction do

        @address = @customer.addresses.build(safe_params)

        @address.default = true if @customer.addresses.count == 0

        if !request.xhr? && @address.save
          redirect_to [:seller,@customer], flash: { notice: t('shoppe.addresses.created_successfully') }
        else
          render action: 'new'
        end

        # if !request.xhr? && @order.save
        #   @order.confirm!
        #   redirect_to [:seller,@order], flash: { notice: t('shoppe.orders.create_notice') }
        # else
        #   @order.order_items.build(ordered_item_type: 'Product')
        #   render action: 'new'
        # end
      end

    end

    def update
      @address.update_attributes(safe_params)
      if !request.xhr? && @address.save
        redirect_to [:seller,@customer], flash: { notice: t('shoppe.addresses.updated_successfully') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @address.destroy
      redirect_to [:seller,@customer], flash: { notice: t('shoppe.addresses.deleted_successfully') }
    end

    private

    def safe_params
      params[:address].permit(:address_type, :address1, :address2, :address3, :address4, :postcode, :country_id,:pid,:cid,:sid)
    end
  end
end