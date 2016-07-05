module Seller
  class DashboardController < Seller::ApplicationController
    def home
      redirect_to [:seller,:orders]
    end
  end
end
