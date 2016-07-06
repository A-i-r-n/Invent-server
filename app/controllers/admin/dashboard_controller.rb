module Admin
  class DashboardController < Admin::BaseController
    def index
      redirect_to [:admin,:orders]
    end
  end
end
