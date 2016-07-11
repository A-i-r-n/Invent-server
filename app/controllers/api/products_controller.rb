module Api
  class ProductsController < Api::BaseController

    before_action :set_product, only: [:show, :edit, :update, :destroy ,:images]

    def index

      conditions =
          case
            when params[:product_category_id]
              ['product_categorizations.product_category_id = ?', params[:product_category_id]]
            else
              []
          end

      @products_paged = Product.includes(:translations, :stock_level_adjustments, :product_categories, :variants)
                            .order(:name)
                            .where(conditions)
      @products = @products_paged.page(params[:page])
      # .group_by(&:product_category)
      # .sort_by { |cat, _pro| cat.name }

      # render json: @products
    end

    def show
    end

    def images
      @attachments = @product.attachments
    end

    private
    def set_product
      @product = Product.find(params[:id])
    end
  end
end