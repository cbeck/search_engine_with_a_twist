class Admin::SitesController < ApplicationController
  before_filter :admin_required, :hide_bookmarks, :set_nav
  
  # GET /admin_sites
  # GET /admin_sites.xml
  def index
    @site_search = params[:site_search]
    conditions = ["disabled is NULL or disabled != ?", true]
    conditions = ["(disabled is NULL or disabled != ?) and (url like ? or name like ?)", true, "%#{@site_search}%", "%#{@site_search}%"] unless @site_search.nil?
    @sites = Site.paginate(:all, :conditions => conditions, :order => "name ASC", :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sites }
    end
  end

  # removed other methods - now using site controller
end
