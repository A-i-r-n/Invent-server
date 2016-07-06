module Api
  class BaseController < ApplicationController

    # before_filter :login_required

    private

    def login_with_demo_mode
      @user = User.first if Shoppe.settings.demo_mode?
    end

    helper_method :current_user, :logged_in?
  end
end