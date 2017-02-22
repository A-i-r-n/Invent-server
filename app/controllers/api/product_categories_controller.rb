module Api
  class ProductCategoriesController < Api::BaseController

    def index
      # conditions = {}
      # params[:vendor_id]  && conditions.merge!({vendor_id: params[:vendor_id]})
      conditions = {vendor_id: params[:vendor_id]}
      @product_categories = ProductCategory.parent_id(params[:product_category_id]).where(conditions).ordered.page(params[:page])
    end

  end
end