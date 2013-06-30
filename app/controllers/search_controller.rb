class SearchController < ApplicationController
  # protect_from_forgery :only => [:new]
  skip_before_filter :verify_authenticity_token#, :find_search
  self.allow_forgery_protection = false 
  caches_action :new
  caches_action :show, :cache_path => :show_cache_path.to_proc
  
  def show_cache_path
    "#{request.host}#{request.path}"
  end

  def index
    redirect_to '/'
  end
  
  def new
    @search = Search.new({}, request.host)  
    if @search.msa_link.nil?
      @flash_filename = "usa"
      @msas = MetroServiceArea.find :all, :include => [:domain], 
        :conditions => ['homepage is not null'], :order => 'homepage'
      @not_local = true
    else
      @msa = MetroServiceArea.find_by_link_name(@search.msa_link)
      if @msa.nil? || @msa.children.empty?
        @search = Search.new(params, request.host)
        @search.execute
        if @search.sites.blank?
          redirect_to suggest_url(:site_not_found => "true", :searched_for => params[:term])
        else
          render :action => 'show'
        end
        return
      else
       @flash_filename = @msa.flash_filename || "usa"
       @msas = @msa.children
      end
    end
    @categories = Topic.find :all, :include => [:domain],
        :conditions => ['parent_id is null and name is not null'], :order => 'name'
    @search_home = true    
  end
  
  def show
    @search = Search.new(params, request.host)
    unless @search.domain_alt.nil?
      redirect_to @search.domain_alt
      return
    end 
    
    @search.execute
    # search_page unless params[:page].blank?
    if @search.sites.blank?
      redirect_to suggest_url(:site_not_found => "true", :searched_for => params[:term])
    end
  end
  
  def create
    unless params[:search].nil?
      params[:search].delete 'activity'
      @search = Search.new(params[:search], request.host)
      redirect_to @search.domain_alt unless @search.domain_alt.nil?
      
      @search.execute
      if @search.sites.blank?
        redirect_to suggest_url(:site_not_found => "true", :searched_for => params[:term])
      else
        @request_url = [request.url, params[:search][:term]].join("/")
        render :action => 'show'    
      end
    else
      redirect_to '/'
    end
  end
  
  def search_page
    # @search = Search.new(params)
    # @search.execute
    
    # temp comment for when i get ajax pagination working - just out of time
    # if request.xhr?
    #   if @search.sites.empty?
    #     render(:text => "No results!")
    #   else
    #     render(:partial => "site", :collection => @search.sites, :layout => false)
    #   end
    # else
    #   render :nothing => true
    # end
    render :update do |page|
      page.insert_html :bottom, 'results-list', :partial => 'site', :collection => @search.sites
      page.replace_html 'next_page', :partial => 'next_page'
    end
  end
  
  def pcreate    
    unless @sites.blank?
      render :update do |page|
        page.replace_html 'search_results', :partial => 'results'
        page.replace_html 'search_topics', :partial => 'sub_topics'
        page.replace_html 'search_preferred', :partial => 'preferred_links'
        page.replace_html 'search_msa', :partial => 'msa_links'
        page.replace_html 'search_related', :partial => 'related_topics'
        page.replace_html 'search_history', :partial => 'history'
      end
    else
      render :update do |page|
        # FIXME: create better empty set response
        page.replace_html 'search_results', 'no results found'
      end
    end
  end
      
end
