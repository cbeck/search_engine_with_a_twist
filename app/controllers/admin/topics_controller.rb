class Admin::TopicsController < ApplicationController
  before_filter :admin_required, :hide_bookmarks, :set_nav
  
  # GET /topics
  # GET /topics.xml
  def index
    @topic_search = params[:topic_search]
    conditions = ["name like ?", "%#{@topic_search}%"] unless @topic_search.nil?
    @topics = Topic.paginate(:all, :conditions => conditions, :order => "name ASC", :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = Topic.new
    @super_categories = Topic.ordered_roots

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
    @super_categories = Topic.ordered_roots
  end

  # POST /topics
  # POST /topics.xml
  def create
    # MUST REFACTOR!
    if params[:primary_category] && !params[:primary_category][:id].blank?
      parent_topic = Topic.find(params[:primary_category][:id])
    end
    if params[:super_category] && !params[:super_category][:id].blank?
      super_cat = Topic.find(params[:super_category][:id])
      parent_topic ||= super_cat
    end
    @topic = Topic.new params[:topic]
    if (super_cat.nil?)
      @topic = Topic.create(:name => params[:topic][:name])
      @topic.update_attribute(:root_id, @topic.id)
      success = true
    else
      @topic = Topic.create(:name => params[:topic][:name], :root_id => super_cat.id)
      success = true
    end
    respond_to do |format|
      if success
        # disabling moving to new super cats right now
        # @topic.update_attribute(:root_id, super_cat.id) unless super_cat.nil?
        unless parent_topic.nil?
          @topic.move_to_child_of parent_topic 
        end       
        flash[:notice] = "Topic #{@topic.name} was successfully created."
        format.html { redirect_to([:admin, @topic]) }
        format.xml  { render :xml => @topic, :status => :created, :location => [:admin, @topic] }
      else
        flash[:notice] = "There was a problem creating this topic."
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    #MUST REFACTOR!
    @topic = Topic.find(params[:id])
    # parent_id = @topic.id

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        if params[:primary_category] && !params[:primary_category][:id].blank?
          parent_topic = Topic.find(params[:primary_category][:id])
        end
        if params[:super_category] && !params[:super_category][:id].blank?
          super_cat = Topic.find(params[:super_category][:id])
          parent_topic ||= super_cat
        end
        unless parent_topic.nil?
          if @topic.root_id != super_cat.id
            @topic.root_id = super_cat.id
            @topic.save
          end
          if @topic.parent_id != parent_topic.id
            begin
              @topic.move_to_child_of parent_topic
            rescue
              flash[:notice] = "There was a problem updating this topic.  Did you try to move a super category under another super category?"
              redirect_to(admin_topics_path)
            end
          end
        end
        flash[:notice] = 'Topic was successfully updated.'
        format.html { redirect_to(admin_topics_path) }
        format.xml  { head :ok }
      else
        flash[:notice] = "There was a problem updating this topic.  Did you try to move a super category under another super category?"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(admin_topics_path) }
      format.xml  { head :ok }
    end
  end
  
  def load_primary_topics
     @primary_topics = load_topics(params[:id])
     render :update do |page|
       page.replace_html 'primary_topics', :partial => 'primary_topics' 
     end
  end
   
  private 
  
  def load_topics(parent_topic)
      Topic.find_all_by_parent_id(parent_topic, :order => "name ASC")
  end
end
