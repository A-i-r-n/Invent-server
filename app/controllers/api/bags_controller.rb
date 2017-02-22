module Api
  class BagsController < Api::BaseController

    def index
      @bags = Bag.all
    end

  end
end