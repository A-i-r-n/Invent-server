module Api
  class BannersController < Api::BaseController

    def index
      @banners = Banner.all
    end

  end
end