class ProductsController <  ApplicationController
  def index
    @products_paged = Product.root
                          .includes(:translations, :stock_level_adjustments, :product_categories, :variants)
                          .order(:name)
    if params[:category_id].present?
      @products_paged = @products_paged
                            .where('product_categorizations.product_category_id = ?', params[:category_id])
    end

    case
      when params[:sku]
        @products_paged = @products_paged
                              .with_translations(I18n.locale)
                              .page(params[:page])
                              .ransack(sku_cont_all: params[:sku].split).result
      when params[:name]
        @products_paged = @products_paged
                              .with_translations(I18n.locale)
                              .page(params[:page])
                              .ransack(translations_name_or_translations_description_cont_all: params[:name].split)
                              .result
      else
        @products_paged = @products_paged.page(params[:page])
    end

    @products = @products_paged
                    .group_by(&:product_category)
                    .sort_by { |cat, _pro| cat.name }

  end
end