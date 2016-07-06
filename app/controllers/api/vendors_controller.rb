module Api
  class VendorsController < Api::BaseController
    def index
      @vendors_paged = Vendor.order(:name)
      @vendors = @vendors_paged.page(params[:page] ||= 1)
    end
  end
end