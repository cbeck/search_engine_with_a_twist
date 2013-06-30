class SiteController < ApplicationController
  skip_before_filter :verify_authenticity_token
  self.allow_forgery_protection = false 
  
  before_filter :admin_required, :only => [:admin]
  #before_filter :login_required, :only => [:welcome]
  before_filter :hide_bookmarks, :only => [:admin, :agreement, :privacy, :contact, :advertising]
  before_filter :set_nav, :except => [:index]
  caches_action :hall_of_fame
  
  def index
    unless logged_in?
      @splash = "splash"
      render :action => 'welcome'
    end
  end
  
  def admin
    @site_search = params[:site_search] unless params[:site_search].blank?
    unless params[:include_loader].blank?
      session[:include_loader] = params[:include_loader] == 'true'
    end
    @include_loader = session[:include_loader] || false
    
    unless @include_loader
      loader_cond = " and user_id is not NULL"
    else
      loader_cond = ""
    end      
    
    if @site_search.nil?
      conditions = ["disabled = ? #{loader_cond}", true]
    else
      conditions = ["(url like ? or name like ?) and disabled = ? #{loader_cond}", "%#{@site_search}%", "%#{@site_search}%", true] 
    end
    @sites = Site.paginate(:all, :conditions => conditions, :order => "created_at DESC, user_id DESC, url ASC", :page => params[:page])
  end  
  
  def hall_of_fame
    @users = User.find(:all).select {|u| u.is_ubsomething?}.reject {|u| u.admin?}
  end
  
  def demo
    @hide_bookmarks = true
    @show_nav = false
    # render :layout => false
  end
  
  def maintenance
    render :layout => false
  end

  def maintenance_youtube
    render :layout => false
  end
  
  
end
