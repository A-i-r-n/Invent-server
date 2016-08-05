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

      conditions.merge!(status:'accepted')

      @vendors_paged = Vendor.with_distance(location).where(conditions).order_by(location,params[:order_by_distance] == '1')

      @vendors = @vendors_paged.page(params[:page] ||= 1)

    end

    def settle_in
      @vendor = current_vendor
      if request.post?
        @vendor.update_attributes(safe_params)
        if !@vendor.save
          return render_json_error_message(e_msg(@vendor))
        end
      end
      render 'vendor'
    end

    private
    def safe_params
      params[:vendor][:sid] ||= nil
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:vendor].permit(:name,:pid,:cid,:sid,:product_category_id,attachments: [ image: file_params ]
      )
    end

    def current_vendor
      vendor = current_user.vendor || Vendor.new
      vendor.user = current_user
      vendor
    end
  end
end