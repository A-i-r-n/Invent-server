module Api
  class VendorsController < Api::BaseController

    before_action :login_required ,only:[:settle_in]

    def index
      conditions = {}
      ! params[:product_category_id].blank? &&  conditions.merge!({product_category_id: params[:product_category_id] })
      ! params[:area_id].blank? && conditions.merge!({})
      ! params[:siftings].blank? && conditions.merge!({})

      @vendors_paged = Vendor.where(conditions).order(:name)
      @vendors = @vendors_paged.page(params[:page] ||= 1)
    end

    def settle_in

      @vendor = current_vendor

      if request.post?
        @vendor.user = current_user
        @vendor.update_attributes(safe_params)
        if @vendor.save
          render 'vendor'
        else
          {code: 0,msg:"#{@vendor.errors.full_messages[0]}"}.tap do |msg|
            render 'shared/error',@msg = msg
          end
        end
      else
        render 'vendor'
      end


    end

    private
    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:vendor].permit(
          :name,
          attachments: [ image: file_params ]
      )
    end

    def current_vendor
      current_user.vendor || Vendor.new
    end
  end
end