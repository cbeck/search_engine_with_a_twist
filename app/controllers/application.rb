# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # before_filter :login_required, :if => :remote_ip_unknown?
  
  helper :all # include all helpers, all the time
  helper_method :current_user
  layout "ubexact"
  # session :off, :if => lambda {|req| req.user_agent =~ /(Google|Slurp)/i}
  include AuthenticatedSystem
  include SslRequirement
  skip_before_filter :ensure_proper_protocol if RAILS_ENV == "development"
  include ExceptionNotifiable
  # before_filter :forward_domain_query
  before_filter :login_from_cookie
  #before_filter :find_search

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '229506eddac0cf99702d8fb20cd15a52'
  self.allow_forgery_protection = false

  # these are added to support polymorphic associations
  # see http://rubyurl.com/E5l 
  protected
  class << self
    attr_reader :parents
    def parent_resources(*parents)
      @parents = parents
    end
  end
  
  def remote_ip_unknown?
    unless ["development", "test"].include? RAILS_ENV
      ips = CACHE.get('remote_ips_allowed') || ['127.0.0.1']
      !ips.include?(request.remote_ip)
    else
      false
    end
  end
  
  def remember_ip_address(ip)
    unless ["development", "test"].include? RAILS_ENV
      ips = CACHE.get('remote_ips_allowed')
      unless ips.nil?
        ips << ip
        CACHE.set 'remote_ips_allowed', ips.uniq, 60*60*12
      else
        CACHE.add 'remote_ips_allowed', [ip], 60*60*12
      end
    end
  end
  
  # def forward_domain_query
  #   term = Search.domain_query(request.host)
  #   redirect_to("http://#{MY_HOST}/search/#{term}") unless term.nil?
  # end
  
  # def forward_domain_query
  #     if Search.domain_query? request.host
  #       redirect_to("http://#{MY_HOST}/search/#{$1}")
  #     end
  #   end

  def parent_id(parent)
    request.path_parameters["#{ parent }_id"]
  end

  def parent_type
    self.class.parents.detect { |parent| parent_id(parent) }
  end

  def parent_class
    parent_type && parent_type.to_s.classify.constantize
  end

  def parent_object
    parent_class && parent_class.find_by_id(parent_id(parent_type))
  end

  def admin_required
    (logged_in? && current_user.admin?) ? true : access_denied
  end

  def one_column(width=500)
    @one_column = true
    @page_width = width unless width.nil?
  end
  
  # def find_search
  #     @search ||= Search.new(params, request.host)    
  #   end
  
  def hide_bookmarks
     @hide_bookmarks = true
  end
  
  def set_nav
    @show_nav = true
  end
  
end
