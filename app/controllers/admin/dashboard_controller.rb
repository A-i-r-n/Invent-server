module Admin
  class DashboardController < Admin::BaseController
    def index
      redirect_to [:admin,:vendors]
    end
  end
end
