class SitesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  protect_from_forgery :only => [:create, :delete, :update]
  before_filter :login_required, :except => [:new, :create, :show]
  before_filter :hide_bookmarks, :except => [:new]
  before_filter :set_nav, :only => [:index, :show, :new, :edit]
  
  # GET /sites/1
  # GET /sites/1.xml
  def show
    @site = Site.find(params[:id])
    @submitted = params[:submitted]

    respond_to do |format|
      format.html # show.html.erb
      # format.xml  { render :xml => @site }
    end
  end

  # GET /sites/new
  # GET /sites/new.xml
  def new
    @site = Site.new
    @site_not_found = true unless params[:site_not_found].blank? 
    if @site_not_found
      @searched_for = params[:searched_for]
    end 
    @super_categories = Topic.ordered_roots
    if logged_in?
      hide_bookmarks
    end

    respond_to do |format|
      format.html # new.html.erb
      # format.xml  { render :xml => @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = Site.find(params[:id])
    @super_categories = Topic.ordered_roots
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(params[:site])
    @site.disabled = !(logged_in? && current_user.admin?)
    # @site = load_site_msa(@site)
    @site.user = (logged_in?) ? current_user : nil
    @site.build_key_phrases(params[:key_phrase])
    if params[:metro_service_area].blank? || (params[:msa_indicator] == "no_msa" || params[:msa_indicator] == "all_msas")
      @site.online = true
      @site.city = nil
      @site.metro_service_area = nil 
      @site.all_msas = (params[:msa_indicator] == "all_msas")
    else
      @site.metro_service_area = MetroServiceArea.find_or_create_by_name(params[:metro_service_area][:name])
      @site.online = true if params[:msa_indicator] == "online_plus_msa" || params[:msa_indicator] == "online_plus_all_msas"
      if !params[:country].nil? && !params[:country][:name].blank?
        country_code = Country.find_by_name(params[:country][:name].upcase)
        @site.country_code = country_code.code unless country_code.nil?
      end
      @site.all_msas = (params[:msa_indicator] == "online_plus_all_msas")
    end
    
    if logged_in? && current_user.is_ubexpert?
      @site.country_code ||= Country.find_by_name('ONLINE').code 
    end
    
    unless params[:comments].blank? 
      comments = Comment.new(:comment => params[:comments])
      unless params[:searched_for].blank?
        comments.comment += " -- Search parameter was #{params[:searched_for]}."
      end
      @site.comments << comments
    end 
    
    # @site.disable_ferret if @site.disabled?
    
    respond_to do |format|
      if @site.save 
        flash[:notice] = 'Site was successfully submitted.'
        format.html { redirect_to(site_path(@site)) }
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        @super_categories = Topic.roots
        set_nav
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
    
  end
  
  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @site = Site.find(params[:id])
    @site.build_key_phrases(params[:key_phrase])
    
    if params[:msa_indicator] == "no_msa" || params[:msa_indicator] == "all_msas"
      @site.online = true
      @site.metro_service_area = nil
      params[:site][:city] = nil
      params[:site][:country_code] = nil
      params[:site][:state] = nil
      @site.all_msas = (params[:msa_indicator] == "all_msas")
    else
      @site.online = (params[:msa_indicator] == "online_plus_msa" || params[:msa_indicator] == "online_plus_all_msas")
      @site.metro_service_area = MetroServiceArea.find_or_create_by_name(params[:metro_service_area][:name]) unless params[:metro_service_area][:name].blank?
      @site.all_msas = (params[:msa_indicator] == "online_plus_all_msas")
    end
    
    unless params[:comments].blank? 
      comments = Comment.new(:comment => params[:comments])
      @site.comments << comments
    end
    
    respond_to do |format|
      if @site.update_attributes(params[:site])
        # if @site.ferret_enabled?
        #   if @site.disabled?
        #     @site.ferret_destroy
        #   else
        #     @site.ferret_update
        #   end
        # else
        #   @site.ferret_create unless @site.disabled?
        # end       
        flash[:notice] = 'Site was successfully updated.'
        format.html { redirect_to(@site) }
        format.xml  { head :ok }
      else
        @super_categories = Topic.roots
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { 
        flash[:notice] = 'Site was successfully removed.'
        if current_user.admin? 
          redirect_to admin_path
        else
          redirect_to(sites_url)
        end
      }
      format.xml  { head :ok }
    end
  end

  auto_complete_for :metro_service_area, :name

   def load_primary_topics
     @primary_topics = load_topics(params[:id])
     render :update do |page|
       page.replace_html 'primary_topics', :partial => 'primary_topics' 
       page.replace_html 'sub_topics', :partial => 'empty_topics'     
     end
   end

   def load_sub_topics
     @sub_topics = load_topics(params[:id])
     render :update do |page|
       page.replace_html 'sub_topics', :partial => 'sub_topics'      
     end
   end

   private

   def load_topics(parent_topic)
     Topic.find_all_by_parent_id(parent_topic, :order => "name ASC")
   end
   
   # def load_site_msa(site)
   #   if !params[:metro_service_area].nil? && !params[:metro_service_area][:name].blank?
   #     msa = MetroServiceArea.find_by_name(params[:metro_service_area][:name]) 
   #     if msa.nil? 
   #       msa = MetroServiceArea.find_by_name("Online")
   #       site.country_code = Country.find_by_name('ONLINE').code
   #     end
   #     site.metro_service_area = msa
   #   end
   #   site
   # end
end
