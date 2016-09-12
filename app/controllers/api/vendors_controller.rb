module Api
  class VendorsController < Api::BaseController

    before_action :login_required ,only:[:settle_in,:accept]

    before_filter {params[:id] && @vendor = Vendor.find(params[:id])}

    def index
      conditions = {}
      location = {}
      ! params[:product_category_id].blank? &&  conditions.merge!({product_category_id: params[:product_category_id] })
      ! params[:sid].blank? && conditions.merge!({sid: params[:sid]})
      ! params[:siftings].blank? && conditions.merge!({})
      ! params[:lat].blank? && ! params[:lng].blank? && location.merge!({lat: params[:lat],lng: params[:lng]})
      conditions.merge!(status:'accepted')

      @vendors_paged = Vendor.role_for_agglomeration(params[:agglomeration] == '1')
                           .keywords_ransack(params[:keywords])
                           .with_distance(location)
                           .where(conditions)
                           .order_by(location,params[:order_by_distance] == '1')

      @vendors = @vendors_paged.page(params[:page] ||= 1)

    end

    def show
      render 'vendor'
    end


    def settle_in
      @vendor = current_vendor
      if request.post?
        @vendor.update_attributes(safe_params)
        case params[:method]
          when 'edit'
            @vendor.status = 'confirming'
          when 'submit'
            @vendor.status =  'received'
        end
        if ! @vendor.save
          return render_json_error_message(e_msg(@vendor))
        end
      end
      render 'vendor'
    end

    def share
      render layout: false
    end

    private
    def safe_params
      params[:vendor][:sid] ||= nil
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:vendor].permit(:name,:pid,:cid,:sid,:address,:latitude,:longitude,:product_category_id,:keywords,attachments: [ image: file_params ]
      )
    end

    def current_vendor
      Vendor.find_or_create_by(user: current_user)
    end
  end
end