module Api
  class UsersController < Api::BaseController

    before_action :login_required

    def addresses
      @addresses = Address.where(customer: current_user.customer).page(params[:page]||=1)
    end

    def unread_count

    end

  end
end