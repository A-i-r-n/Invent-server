module Seller
  class ProductCategoriesController < Seller::ApplicationController
    before_filter { @active_nav = :product_categories }
    before_filter { params[:id] && @product_category = ProductCategory.find(params[:id]) }

    def index
      @product_categories_without_parent = ProductCategory.root(current_user.vendor).without_parent.ordered
    end

    def new
      @product_category = ProductCategory.new
    end

    def create
      @product_category = ProductCategory.new(safe_params)
      @product_category.vendor = current_user.vendor
      if @product_category.save
        redirect_to [:seller,:product_categories], flash: { notice: t('shoppe.product_category.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def update
      if @product_category.update(safe_params)
        redirect_to [:edit,:seller, @product_category], flash: { notice: t('shoppe.product_category.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @product_category.destroy
      redirect_to [:seller,:product_categories], flash: { notice: t('shoppe.product_category.destroy_notice') }
    end

    private

    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:product_category].permit(:name, :permalink, :description, :parent_id, :permalink_includes_ancestors, attachments: [image: file_params])
    end
  end
end
