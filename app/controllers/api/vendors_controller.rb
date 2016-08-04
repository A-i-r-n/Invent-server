module Api
  class VendorsController < Api::BaseController

    before_action :login_required ,only:[:settle_in]

    def index
      conditions = {}
      location = {}
      ! params[:product_category_id].blank? &&  conditions.merge!({product_category_id: params[:product_category_id] })
      ! params[:sid].blank? && conditions.merge!({sid: params[:sid]})
      ! params[:siftings].blank? && conditions.merge!({})
      ! params[:lat].blank? && ! params[:lng].blank? && location.merge!({lat: params[:lat],lng: params[:lng]})

      @vendors_paged = Vendor.with_distance(location).where(conditions).order_by(location,params[:order_by_distance] == '1')

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
          render_json_error_message(e_msg(@vendor))
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