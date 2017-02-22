module Api
  class CosmeticsController < Api::BaseController

    def index
      @cosmetics = Cosmetic.all
    end

  end
end