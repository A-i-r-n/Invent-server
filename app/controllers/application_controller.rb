class ApplicationController < ActionController::Base
  protect_from_forgery

  include ::LoginSystem


  rescue_from ActiveRecord::DeleteRestrictionError do |e|
    redirect_to request.referer || root_path, alert: e.message
  end

  rescue_from Shoppe::Error do |e|
    @exception = e
    render layout: 'sub', template: 'shared/error'
  end

  private

  def login_with_demo_mode
    @user = User.first if Shoppe.settings.demo_mode?
  end

  helper_method :current_user, :logged_in?
end