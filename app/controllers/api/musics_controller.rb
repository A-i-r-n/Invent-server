module Api
  class MusicsController < Api::BaseController

    def index
      @musics = Music.all
    end

  end
end