module Seller
  class AccountsController < Seller::BaseController
    # before_action :verify_config
    # before_action :verify_users, only: [:login, :recover_password]
    # before_action :redirect_if_already_logged_in, only: :login

    layout 'seller'
    # skip_before_filter :login_required,except: [:login, :signup]

    def login
      return unless request.post?
      self.current_user = User.admin.authenticate(params[:login], params[:password])
      if logged_in?
        successful_login
      else
        flash[:error] = t('shoppe.sessions.create_alert')
        @login = params[:login]
      end
    end

    def signup

      @user = User.new((params[:user].permit! if params[:user]))

      return unless request.post?

      # @user.generate_password!
      session[:tmppass] = @user.password
      @user.name = @user.login
      if @user.save
        self.current_user = @user
        session[:user_id] = @user.id

        redirect_to login_admin_accounts_path

        return
      end
    end

    # def recover_password
    #   return unless request.post?
    #   @user = User.where('login = ? or email = ?', params[:user][:login], params[:user][:login]).first
    #
    #   if @user
    #     @user.generate_password!
    #     @user.save
    #     flash[:notice] = t('accounts.recover_password.notice')
    #     redirect_to login_accounts_url
    #   else
    #     flash[:error] = t('accounts.recover_password.error')
    #   end
    # end
    #
    def logout
      flash[:notice] = t('shoppe.sessions.back_to_login')
      current_user.forget_me
      self.current_user = nil
      session[:user_id] = nil
      cookies.delete :auth_token
      cookies.delete :publify_user_profile
      redirect_to login_admin_accounts_path
    end
    #
    # private
    #
    # def verify_users
    #   redirect_to(controller: 'accounts', action: 'signup') if User.count == 0
    #   true
    # end
    #
    # def verify_config
    #   redirect_to controller: 'setup', action: 'index' unless this_blog.configured?
    # end
    #
    # def redirect_if_already_logged_in
    #   if session[:user_id] && session[:user_id] == current_user.id
    #     redirect_back_or_default
    #   end
    # end

    def successful_login
      session[:user_id] = current_user.id
      if params[:remember_me] == '1'
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = {
            value: current_user.remember_token,
            expires: current_user.remember_token_expires_at,
            httponly: true # Help prevent auth_token theft.
        }
      end
      # add_to_cookies(:publify_user_profile, current_user.profile_label, '/')

      current_user.update_connection_time
      flash[:success] = t('shoppe.sessions.admin_login')
      redirect_back_or_default
    end

    def redirect_back_or_default
      redirect_to(session[:return_to] || url_for(controller: :dashboard, action: :index))
      session[:return_to] = nil
    end
  end
end
