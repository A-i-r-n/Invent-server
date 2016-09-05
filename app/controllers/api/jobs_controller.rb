module Api
  class JobsController < Api::BaseController

    # before_filter :login_required,except: [:login, :signup]

    before_filter {params[:id] && @job = Job.find(params[:id])}

    def index
      conditions = {}
      params[:category_id] && conditions.merge!({category_id: params[:category_id]})
      @jobs = Job.where(conditions).active.page(params[:page])
    end

    def show

    end

    def images
      @attachments = @job.attachments
    end

    def detail
      render layout: 'api'
    end

    def categories
      @job_categories = JobCategory.all
    end

  end
end