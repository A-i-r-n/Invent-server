module Api
  class UsersController < Api::BaseController
    def info
      @user = current_user
      render "login"
    end
  end
end