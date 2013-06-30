# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

include AuthenticatedTestHelper

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # config.global_fixtures = :users, :businesses, :locations, :schedules, :people, :affiliates
  
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

# def login_as(user)  
#   case user
#     when :admin
#       @current_user = mock_model(User)     
#       User.should_receive(:find_by_id).any_number_of_times.and_return(@current_user)
#       request.session[:user] = @current_user
#     when :normal
#       request.session[:user] = users(user)
#     else
#       request.session[:user] = nil
#   end
# end

# see http://www.danielfischer.com/2007/11/06/new-rspec-pattern-to-dry-up-your-controller-specs/
[:get, :post, :put, :delete, :render].each do |action|
  eval %Q{
    def before_#{action}
      yield
      do_#{action}
    end
    alias during_#{action} before_#{action}
    def after_#{action}
      do_#{action}
      yield
    end
  }
end

# Monkeypatch so we can turn of sessions for Robots.  See The Rails Way, p 472
class ActionController::TestRequest
  def user_agent
    "Mozilla/5.0"
  end
end
