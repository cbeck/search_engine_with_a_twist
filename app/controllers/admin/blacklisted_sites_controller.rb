class Admin::BlacklistedSitesController < ApplicationController
  before_filter :admin_required, :hide_bookmarks, :set_nav
  # GET /blacklisted_sites
  # GET /blacklisted_sites.xml
  def index
    @blacklisted_site_search = params[:blacklisted_site_search]
    conditions = ["url like ?", "%#{@blacklisted_site_search}%"] unless @blacklisted_site_search.nil?
    @blacklisted_sites = BlacklistedSite.paginate(:all, :conditions => conditions, :order => "url ASC", :page => params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blacklisted_sites }
    end
  end

  # GET /blacklisted_sites/1
  # GET /blacklisted_sites/1.xml
  def show
    @blacklisted_site = BlacklistedSite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blacklisted_site }
    end
  end

  # GET /blacklisted_sites/new
  # GET /blacklisted_sites/new.xml
  def new
    @blacklisted_site = BlacklistedSite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blacklisted_site }
    end
  end

  # GET /blacklisted_sites/1/edit
  def edit
    @blacklisted_site = BlacklistedSite.find(params[:id])
  end

  # POST /blacklisted_sites
  # POST /blacklisted_sites.xml
  def create
    @blacklisted_site = BlacklistedSite.new(params[:blacklisted_site])

    respond_to do |format|
      if @blacklisted_site.save
        flash[:notice] = 'BlacklistedSite was successfully created.'
        format.html { redirect_to([:admin, @blacklisted_site]) }
        format.xml  { render :xml => @blacklisted_site, :status => :created, :location => @blacklisted_site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blacklisted_site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blacklisted_sites/1
  # PUT /blacklisted_sites/1.xml
  def update
    @blacklisted_site = BlacklistedSite.find(params[:id])

    respond_to do |format|
      if @blacklisted_site.update_attributes(params[:blacklisted_site])
        flash[:notice] = 'BlacklistedSite was successfully updated.'
        format.html { redirect_to([:admin, @blacklisted_site]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blacklisted_site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blacklisted_sites/1
  # DELETE /blacklisted_sites/1.xml
  def destroy
    @blacklisted_site = BlacklistedSite.find(params[:id])
    @blacklisted_site.destroy

    respond_to do |format|
      format.html { redirect_to(admin_blacklisted_sites_url) }
      format.xml  { head :ok }
    end
  end
end
