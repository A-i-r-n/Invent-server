module Api
  class ProductCategoriesController < Api::BaseController
    def index
      @vendor = Vendor.find(params[:vendor_id])
      @product_categories = ProductCategory.root(@vendor).without_parent.ordered.page(params[:page]||=1)
    end
  end
end