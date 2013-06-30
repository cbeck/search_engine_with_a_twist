class Admin::MetroServiceAreasController < ApplicationController
  before_filter :admin_required, :hide_bookmarks, :set_nav
  
  # GET /metro_service_areas
  # GET /metro_service_areas.xml
  def index
    @msa_search = params[:msa_search]
    conditions = ["name like ?", "%#{@msa_search}%"] unless @msa_search.nil?
    @metro_service_areas = MetroServiceArea.paginate(:all, :conditions => conditions, :order => "name ASC", :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @metro_service_areas }
    end
  end

  # GET /metro_service_areas/1
  # GET /metro_service_areas/1.xml
  def show
    @metro_service_area = MetroServiceArea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @metro_service_area }
    end
  end

  # GET /metro_service_areas/new
  # GET /metro_service_areas/new.xml
  def new
    @metro_service_area = MetroServiceArea.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @metro_service_area }
    end
  end

  # GET /metro_service_areas/1/edit
  def edit
    @metro_service_area = MetroServiceArea.find(params[:id])
  end

  # POST /metro_service_areas
  # POST /metro_service_areas.xml
  def create
    @metro_service_area = MetroServiceArea.new(params[:metro_service_area])

    respond_to do |format|
      if @metro_service_area.save
        flash[:notice] = 'MetroServiceArea was successfully created.'
        format.html { redirect_to([:admin, @metro_service_area]) }
        format.xml  { render :xml => @metro_service_area, :status => :created, :location => [:admin, @metro_service_area] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @metro_service_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /metro_service_areas/1
  # PUT /metro_service_areas/1.xml
  def update
    @metro_service_area = MetroServiceArea.find(params[:id])

    respond_to do |format|
      if @metro_service_area.update_attributes(params[:metro_service_area])
        flash[:notice] = 'MetroServiceArea was successfully updated.'
        format.html { redirect_to([:admin, @metro_service_area]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @metro_service_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /metro_service_areas/1
  # DELETE /metro_service_areas/1.xml
  def destroy
    @metro_service_area = MetroServiceArea.find(params[:id])
    @metro_service_area.destroy

    respond_to do |format|
      format.html { redirect_to(admin_metro_service_areas_url) }
      format.xml  { head :ok }
    end
  end
end
