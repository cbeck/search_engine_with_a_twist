# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Dependencies
  # see: http://ryandaigle.com/articles/2008/4/1/what-s-new-in-edge-rails-gem-dependencies
  
  # config.gem "ferret", :version => "0.11.6"
  # config.gem "acts_as_ferret", :version => "0.4.3"
  config.gem "fastercsv", :version => "1.2.3"
  config.gem "SyslogLogger", :version => "1.4.0", :lib => 'syslog_logger'
  config.gem "memcache-client", :version => "1.5.0", :lib => 'memcache'
  config.gem "google-geocode", :lib => 'google_geocode'
  config.gem "chronic", :version => "0.2.3"
  # config.gem "rails_analyzer_tools", :version => "1.4.0"
  # config.gem "production_log_analyzer", :version => "1.5.0"

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  # config.action_controller.session = {
  #   :session_key => '_ubexact_session',
  #   :secret      => '187c72328f859f1248bb72e22829394146df4310f47704638918cf133ad7f7df742ed8df2fea0436669f102866b7cf73b3dbde4a0e5f42aa36e4c8ab4f0eff17'
  # }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store
  config.action_controller.session_store = :mem_cache_store

  # config.action_controller.cache_store = :mem_cache_store, memcache_servers, memcache_options

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :user_observer

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  
  FILE_STORE_PATH = File.join(RAILS_ROOT, "/public/cache/")
  config.action_controller.page_cache_directory = FILE_STORE_PATH
  config.action_controller.cache_store = :file_store, FILE_STORE_PATH
  
end

require 'rails_extensions'

Ultrasphinx::Search.client_options[:finder_methods].unshift(:find_with_includes)

# require 'acts_as_ferret'

# cache_params = *([MEMCACHE_SERVERS, MEMCACHE_OPTIONS].flatten)
# CACHE = MemCache.new *cache_params
# ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.merge!({ 'cache' => CACHE })

# ActionMailer::Base.default_url_options[:host] = 'netphase.com'

CONTACT_EMAIL = 'info@ubexact.com'
SUPPORT_EMAIL = 'support@ubexact.com'
NOREPLY_EMAIL = 'noreply@ubexact.com'

# require 'memory_profiler'
# MemoryProfiler.start
