module Api
  class BaseController < ApplicationController

    # before_filter :login_required

    protect_from_forgery with: :exception, only: [:delete] #[:edit, :update, :delete]

    private

    def login_with_demo_mode
      @user = User.first if Shoppe.settings.demo_mode?
    end

    def render_json_error_message(msg)
      if ! msg.is_a?(String)
        msg = e_msg(msg)
      end
      {code: 1 ,msg: msg}.tap do |msg|
        render 'shared/error',@msg = msg
      end
    end

    def render_json_success_message(msg)
      if ! msg.is_a?(String)
        msg = e_msg(msg)
      end
      {code: 0 ,msg: msg}.tap do |msg|
        render 'shared/success',@msg = msg
      end
    end

    def e_msg(obj)
      obj.errors.full_messages.to_sentence
    end

    alias :render_error :render_json_error_message

    alias :render_success :render_json_success_message


    helper_method :current_user, :logged_in?
  end
end