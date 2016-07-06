require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# require File.expand_path('../../lib/shoppe', __FILE__)

module Server
  class Application < Rails::Application
    # isolate_namespace Shoppe

    # config.middleware.insert_before 0, "Rack::Cors", :debug => true, :logger => (-> { Rails.logger }) do
    #   allow do
    #     origins '*'
    #     resource '*',
    #              :headers => :any,
    #              :methods => [:get, :post, :delete, :put, :patch, :options, :head]
    #   end
    # end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :zh

    config.active_record.default_timezone = :local

    config.time_zone = 'Beijing'

    config.i18n.default_locale = "zh-CN"


    # config.i18n.fallbacks = {:"pt-BR"=>'en'}

    # config.web_console.whiny_requests = false

    # config.web_console.whitelisted_ips = '192.168.0.0/16'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.active_job.queue_adapter = :sidekiq
    #   config.assets.precompile << proc.new do |path|
    #            if path =~ /\.(css|js |scss|png|jpg|gif|js on)\z/
    #              full_path = rails.application.assets.resolve(path).to_path
    #              app_assets_path1 = rails.root.join('app', 'assets').to_path
    #              app_assets_path2 = rails.root.join('public', 'assets').to_path
    #              app_assets_path3 = rails.root.join('vendor', 'assets').to_path
    #
    #              if full_path.starts_with? app_assets_path1
    #               true
    #              else
    #                if full_path.starts_with? app_assets_path2
    #                  true
    #                else
    #                  if full_path.starts_with? app_assets_path3
    #                    true
    #                  else
    #                    false
    #                  end
    #             end
    #          end
    #      end
    #    end



    #custom start

    if Rails.respond_to?(:root)
      config.autoload_paths << File.join(Rails.root, 'lib')
      config.assets.precompile += ['sub.css', 'printable.css']
    end

    # We don't want any automatic generators in the engine.
    config.generators do |g|
      g.orm             :active_record
      g.test_framework  false
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end

    config.to_prepare do
      Dir.glob(Rails.root + 'app/decorators/**/*_decorator*.rb').each do |c|
        require_dependency(c)
      end
    end

    initializer 'initialize' do |app|
      # Add the default settings
      Shoppe.add_settings_group :system_settings, [:store_name, :email_address, :currency_unit, :tax_name, :demo_mode]

      # Add middleware
      app.config.middleware.use Shoppe::SettingsLoader

      # Load our migrations into the application's db/migrate path
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end

      # Load view helpers for the base application
      ActiveSupport.on_load(:action_view) do
        require 'shoppe/view_helpers'
        ActionView::Base.send :include, Shoppe::ViewHelpers
      end

      ActiveSupport.on_load(:active_record) do
        require 'shoppe/model_extension'
        ActiveRecord::Base.send :include, Shoppe::ModelExtension
      end

      #Load default navigation
      require 'shoppe/default_navigation'
    end

    generators do
      require 'shoppe/setup_generator'
    end

    require 'shoppe'
    #custom end



  end



end
