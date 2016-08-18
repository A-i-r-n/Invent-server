module Api
  class ProductCategoriesController < Api::BaseController

    def index
      conditions = {vendor_id: params[:vendor_id]}
      @product_categories = ProductCategory.without_parent.where(conditions).ordered.page(params[:page])
    end

  end
end