module Api
  class GradesController < Api::BaseController

    before_filter :login_required,except: [:login, :signup]

    def index
      @grades = Grade.where(user:current_user).page(params[:page])
    end

    def create
      @grade = Grade.new(safe_params)
      @grade.user = current_user
      if @grade.save
        render 'grade'
      else
        render_json_error_message(e_msg(@grade))
      end
    end

    private
    def safe_params
      params[:grade].permit(:score,:content,:order_id)
    end

  end
end