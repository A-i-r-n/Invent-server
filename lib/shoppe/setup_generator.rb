require 'rails/generators'
module Shoppe
  class SetupGenerator < Rails::Generators::Base
    def create_route
      route 'mount Rails.application => "/shoppe"'
    end
  end
end
