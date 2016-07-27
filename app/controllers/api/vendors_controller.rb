module Api
  class VendorsController < Api::BaseController
    def index
      conditions = {}
      ! params[:product_category_id].blank? &&  conditions.merge!({product_category_id: params[:product_category_id] })
      ! params[:area_id].blank? && conditions.merge!({})
      ! params[:siftings].blank? && conditions.merge!({})

      @vendors_paged = Vendor.where(conditions).order(:name)
      @vendors = @vendors_paged.page(params[:page] ||= 1)
    end

  end
end