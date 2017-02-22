module Api
  class ShoesController < Api::BaseController

    def index
      @shoes = Shoe.all
    end

  end
end