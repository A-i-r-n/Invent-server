module Admin
  class LotteriesController < Admin::BaseController
    before_filter { @active_nav = :lotteries }
    before_filter { params[:id] && @lottery = Lottery.find(params[:id]) }

    def index
      @lotteries = Lottery.page(params[:page])
    end

    def new
      @lottery = Lottery.new
    end

    def create
      @lottery = Lottery.new(safe_params)
      if @lottery.save
        redirect_to [:admin,:lotteries], flash: { notice: t('shoppe.products.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def update
      if @lottery.update(safe_params)
        redirect_to [:edit,:admin, @lottery], flash: { notice: t('shoppe.products.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @lottery.destroy
      redirect_to [:admin,:lotteries], flash: { notice: t('shoppe.products.destroy_notice') }
    end

    private

    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:product].permit(:name,:type,:price,:periods, :max_periods, :participants, :max_participants, :description, :status, attachments: [default_image: file_params, data_sheet: file_params, extra: file_params])
    end
  end
end
