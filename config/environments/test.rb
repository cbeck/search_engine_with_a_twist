# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell ActionMailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

config.after_initialize do
#  ActiveMerchant::Billing::Base.mode = :test 

  # class StubGeocoder
  #   def locate
  #     { :latitude => 35.0352, :longitude => -80.8171 }
  #   end
  # end
  
  # We don't want to ping the Google Geocode service everytime we care a new location
#  Location.geocoder = StubGeocoder.new

end

ENV["FERRET_USE_LOCAL_INDEX"] = "1"

MEMCACHE_SERVERS = [ '127.0.0.1:11211' ]

MY_HOST = 'test.host'

