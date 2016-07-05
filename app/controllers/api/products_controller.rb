module Api
  class ProductsController < Api::ApplicationController
    def index

      @products_paged = Product.root
                            .includes(:translations, :stock_level_adjustments, :product_categories, :variants)
                            .order(:name)
      @products = @products_paged.page(params[:page])
                      # .group_by(&:product_category)
                      # .sort_by { |cat, _pro| cat.name }
    end
  end
end