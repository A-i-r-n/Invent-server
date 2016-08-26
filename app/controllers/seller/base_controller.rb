module Seller
  class BaseController < ApplicationController

    layout 'seller'

    before_filter :login_required,except: [:login, :signup]

    before_filter { logout if current_user && current_user.role('vendor').blank? }

    def logout
      flash[:notice] = t('shoppe.sessions.back_to_login')
      current_user.forget_me
      self.current_user = nil
      session[:user_id] = nil
      cookies.delete :auth_token
      cookies.delete :publify_user_profile
      redirect_to login_seller_accounts_path
    end

    private

    def login_with_demo_mode
      @user = User.first if Shoppe.settings.demo_mode?
    end

    helper_method :current_user, :logged_in?
  end
end