module Api
  class AreasController < Api::BaseController

    def index
      conditions = {}
      params[:parent_id].blank? ? conditions.merge!({parent_id: nil}) : conditions.merge!({parent_id: params[:parent_id]})
      @areas = Area.where(conditions)
    end
    def streets
      @area = Area.find_by_name(params[:name])
    end

  end
end