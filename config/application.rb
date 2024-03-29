require 'uri'
require 'rack/jsonp'

#if ENV["MONGOHQ_URL"] 
#  mongo_uri = URI.parse(ENV["MONGOHQ_URL"]) 
#  ENV['MONGOID_HOST'] = mongo_uri.host 
#  ENV['MONGOID_PORT'] = mongo_uri.port.to_s 
#  ENV["MONGOID_USERNAME"] = mongo_uri.user 
#  ENV['MONGOID_PASSWORD'] = mongo_uri.password 
#  ENV['MONGOID_DATABASE'] = mongo_uri.path.gsub("/", "") 
#end

require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

#Encoding.default_external = Encoding::UTF_8 if RUBY_VERSION > "1.9"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Ssg 
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)
    
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = 'zh-CN'

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use rack-jsonp-middleware to process JSONP requests.
    config.middleware.use Rack::JSONP

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.mongoid.observers = :point_observer, :notification_observer, :share_queue_observer
    #added for heroku deployment. suggested https://devcenter.heroku.com/articles/rails3x-asset-pipeline-cedar
    config.assets.initialize_on_precompile = false

  end
end
