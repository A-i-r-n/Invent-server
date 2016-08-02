module Api
  class AreasController < Api::BaseController

    def streets
      @area = Area.find_by_name(params[:name])
    end

  end
end