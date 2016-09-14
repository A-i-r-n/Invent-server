module Admin
  class JobsController < Admin::BaseController
    before_filter { @active_nav = :jobs }
    before_filter { params[:id] && @job = Job.find(params[:id]) }

    def index
      @jobs = Job.page(params[:page])
    end

    def new
      @job = Job.new
    end

    def create
      @job = Job.new(safe_params)
      if @job.save
        redirect_to [:admin,:jobs], flash: { notice: t('shoppe.products.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def update
      if @job.update(safe_params)
        redirect_to [:edit,:admin, @job], flash: { notice: t('shoppe.products.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @job.destroy
      redirect_to [:admin,:jobs], flash: { notice: t('shoppe.products.destroy_notice') }
    end

    private

    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:job].permit(:name,:type,:price,:periods, :max_periods, :participants, :max_participants, :description, :status, :end_time,attachments: [default_image: file_params, data_sheet: file_params, extra: file_params])
    end
  end
end
