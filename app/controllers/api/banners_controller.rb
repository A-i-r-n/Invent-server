module Api
  class BannersController < Api::BaseController

    def index
      # render text: Time.now.to_datetime.strftime('%Q')#DateTime.strptime("1422258129106", '%Q')
      # render text: "%10.1f" % 500
      # render text: URI.encode("hello world")
      # render text: TrackQuery.query_api
      @banners = Banner.all
    end

  end
end