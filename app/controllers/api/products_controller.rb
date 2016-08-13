module Api
  class ProductsController < Api::BaseController

    before_action :set_product, only: [:show, :edit, :update, :destroy ,:images,:variants,:attributes,:detail,:carriage_price]

    def index

      conditions = {}

      params[:product_category_id] && conditions.merge!({product_categorizations:{product_category_id: params[:product_category_id]}})

      params[:product_type] ? conditions.merge!({product_type: params[:product_type] } ) : conditions.merge!({product_type: nil})

      @products_paged = Product.includes(:translations, :stock_level_adjustments, :product_categories, :variants)
                            .order(:name)
                            .where(conditions)
      @products = @products_paged.page(params[:page]||=1)
      # .group_by(&:product_category)
      # .sort_by { |cat, _pro| cat.name }

    end

    def show
    end

    def images
      @attachments = @product.attachments
    end


    def attributes
      @product_attributes = @product.has_variants? ? @product.product_attributes.group_by(&:key) : []
    end

    def carriage_price
      render_json_success_message(@product.carriage_price(params[:cid]))
    end

    def variants
      @products = @product.variants
    end

    def detail
      render 'detail',layout: 'api'
    end

    private
    def set_product
      @product = Product.find(params[:id])
      current_user && @product && VisitorLog.find_or_create_by(user:current_user,parent_type:"Product",parent_id:@product.id)
    end
  end
end