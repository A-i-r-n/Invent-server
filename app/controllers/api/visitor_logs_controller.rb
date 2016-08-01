module Api
  class VisitorLogsController < Api::BaseController

    before_filter :login_required,except: [:login, :signup]

    def index
      @visitor_logs = VisitorLog.where(user:current_user).page(params[:page])
    end

  end
end