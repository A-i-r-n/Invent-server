module Seller
  class SessionsController < Seller::ApplicationController
    layout 'sub'
    skip_before_filter :login_required, only: [:new, :create]

    def create
      if user = User.vendor.authenticate(params[:email_address], params[:password])
        session[:shoppe_user_id] = user.id
        redirect_to [:seller,:orders]
      else
        flash.now[:alert] = t('shoppe.sessions.create_alert')
        render action: 'new'
      end
    end

    def destroy
      session[:shoppe_user_id] = nil
      redirect_to [:seller,:login]
    end
  end
end
