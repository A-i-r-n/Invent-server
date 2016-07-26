module Api
  class ProductCategoriesController < Api::BaseController

    before_filter :init,only: [:index,:categories]

    def index
      @product_categories = ProductCategory.root(@vendor).without_parent.ordered.page(params[:page]||=1)
    end

    private
    def init
      params[:vendor_id] && @vendor = Vendor.find(params[:vendor_id])
    end

  end
end