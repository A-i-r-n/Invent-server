module Api
  class JobsController < Api::BaseController

    # before_filter :login_required,except: [:login, :signup]

    before_filter {params[:id] && @job = Job.find(params[:id])}

    def index
      @jobs = Job.active.where(conditions).page(params[:page])
    end

    def show

    end

    def images
      @attachments = @job.attachments
    end

    def detail
      render layout: 'api'
    end

  end
end