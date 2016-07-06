module Seller
  class DashboardController < Seller::BaseController
    def index
      redirect_to [:seller,:orders]
    end
  end
end
