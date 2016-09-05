module Api
  class ProductsController < Api::BaseController

    before_action :set_product, only: [:show, :edit, :update, :destroy ,:images,:variants,:attributes,:detail,:carriage_price,:user]

    def index

      conditions = {}

      params[:product_category_id] && conditions.merge!({product_categorizations:{product_category_id: params[:product_category_id]}})

      # params[:product_type] ? conditions.merge!({product_type: params[:product_type] } ) : conditions.merge!({product_type: nil})

      @products_paged = Product.includes(:translations, :stock_level_adjustments, :product_categories, :variants)
                            .order(:name)
                            .where(conditions)
      @products = @products_paged.page(params[:page]||=1)
      # .group_by(&:product_category)
      # .sort_by { |cat, _pro| cat.name }

    end

    def show
      render 'product'
    end

    def create
      return render_error("你不是商户") if current_user.vendor.blank?
      @product = Product.new(safe_params)
      @product.vendor = current_user.vendor
      if @product.save
        render 'product'
      else
        render_json_error_message(e_msg(@product))
      end
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

    def user
      @user = User.joins(:vendor).where(" vendors.id ",@product.product_vendor.id).first
    end

    private

    def set_product
      @product = Product.find(params[:id])
      current_user && @product && VisitorLog.find_or_create_by(user:current_user,parent_type:"Product",parent_id:@product.id)
    end

    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:product].permit(:name,:product_type,:max_periods,:max_participants, :sku,
                              :permalink, :description, :short_description, :weight,
                              :price, :cost_price, :tax_rate_id, :stock_control, :active,
                              :featured, :in_the_box,
                              attachments: [default_image: file_params, data_sheet: file_params,
                                            extra: file_params],
                              product_attributes_array: [:key, :value, :searchable, :public],
                              product_category_ids: [],
                              stock_level_adjustments: [:description,:adjustment]
      )
    end
  end
end