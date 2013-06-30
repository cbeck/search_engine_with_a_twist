class Admin::MetroServiceAreaLinksController < ApplicationController
  before_filter :admin_required, :hide_bookmarks, :set_nav
  
  # # GET /admin_metro_service_area_links
  #   # GET /admin_metro_service_area_links.xml
  #   def index
  #     @metro_service_area_links = MetroServiceAreaLink.find(:all)
  # 
  #     respond_to do |format|
  #       format.html # index.html.erb
  #       format.xml  { render :xml => @metro_service_area_links }
  #     end
  #   end
  # 
  #   # GET /admin_metro_service_area_links/1
  #   # GET /admin_metro_service_area_links/1.xml
  #   def show
  #     @metro_service_area_link = MetroServiceAreaLink.find(params[:id])
  # 
  #     respond_to do |format|
  #       format.html # show.html.erb
  #       format.xml  { render :xml => @metro_service_area_link }
  #     end
  #   end

  # GET /admin_metro_service_area_links/new
  # GET /admin_metro_service_area_links/new.xml
  def new
    @metro_service_area_link = MetroServiceAreaLink.new
    msa = MetroServiceArea.find(params[:metro_service_area])
    @metro_service_area_link.metro_service_area = msa

    respond_to do |format|
      format.html # new.html.erb
      format.js #new.js.rjs
      format.xml  { render :xml => @metro_service_area_link }
    end
  end

  # GET /admin_metro_service_area_links/1/edit
  def edit
    @metro_service_area_link = MetroServiceAreaLink.find(params[:id])
  end

  # POST /admin_metro_service_area_links
  # POST /admin_metro_service_area_links.xml
  def create
    @metro_service_area_link = MetroServiceAreaLink.new(params[:metro_service_area_link])

    respond_to do |format|
      if @metro_service_area_link.save
        flash[:notice] = 'MetroServiceAreaLink was successfully created.'
        format.html { redirect_to([:admin, @metro_service_area_link.metro_service_area]) }
        format.xml  { render :xml => @metro_service_area_link, :status => :created, 
                      :location => [:admin, @metro_service_area_link.metro_service_area] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @metro_service_area_link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_metro_service_area_links/1
  # PUT /admin_metro_service_area_links/1.xml
  def update
    @metro_service_area_link = MetroServiceAreaLink.find(params[:id])

    respond_to do |format|
      if @metro_service_area_link.update_attributes(params[:metro_service_area_link])
        flash[:notice] = 'MetroServiceAreaLink was successfully updated.'
        format.html { redirect_to([:admin, @metro_service_area_link.metro_service_area]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @metro_service_area_link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_metro_service_area_links/1
  # DELETE /admin_metro_service_area_links/1.xml
  def destroy
    @metro_service_area_link = MetroServiceAreaLink.find(params[:id])
    @metro_service_area_link.destroy

    respond_to do |format|
      format.html { redirect_to(admin_metro_service_area_path(@metro_service_area_link.metro_service_area)) }
      format.xml  { head :ok }
    end
  end
end
