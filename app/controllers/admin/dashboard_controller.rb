module Admin
  class DashboardController < Admin::ApplicationController
    def home
      redirect_to :orders
    end
  end
end
