module Admin
  class DashboardController < Admin::ApplicationController
    def home
      redirect_to [:admin,:orders]
    end
  end
end
