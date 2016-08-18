module Api
  class LotteriesController < Api::BaseController

    # before_filter :login_required,except: [:login, :signup]

    before_filter {params[:id] && @lottery = Lottery.find(params[:id])}

    def index
      @lotteries = Lottery.page(params[:page])
    end

    def show

    end

    def images
      @attachments = @lottery.attachments
    end

    def detail
      render layout: 'api'
    end

  end
end