require File.dirname(__FILE__) + '/../spec_helper'

describe SearchController do
  controller_name :search
  integrate_views
  fixtures :topics, :sites
  describe "route generation" do

    before(:each) do
      @controller.request = @request
    #   @controller.url = ActionController::UrlRewriter.new @request, {} # url_for
    end

    it "should map { :controller => 'search', :action => 'new' } to /" do
      route_for(:controller => "search", :action => "new").should == "/"
    end
    
    it "should map { :controller => 'search', :action => 'show', :term => 'Banking+Services', }" do
      route_for(:controller => 'search', :action => 'show', :term => 'Banking+Services',
                :topic1 => 'bank', :msa => 'florida').should ==
          "/search/Banking+Services/msa/florida/topic/bank"
    end
    
    # it "should map { :controller => 'search', :action => 'index' } to /topics" do
    #   route_for(:controller => "search", :action => "topic", 
    #     :topic => "art_dealer").should == "/topic/art_dealer"
    # end
    
    # it "should map url_for(topic) to /foobar" do
      # topic = topics(:art)
      # url_for
      # route_for(topic).should == '/foobar'
      # @controller.send :initialize_current_url
      
      # site = sites(:one)
      #     @controller.url_for(site).should == '/foobar'
    # end
  
    # it "should map { :controller => 'topics', :action => 'new' } to /topics/new" do
    #   route_for(:controller => "topics", :action => "new").should == "/topics/new"
    # end
    #   
    # it "should map { :controller => 'topics', :action => 'show', :id => 1 } to /topics/1" do
    #   route_for(:controller => "topics", :action => "show", :id => 1).should == "/topics/1"
    # end
    #   
    # it "should map { :controller => 'topics', :action => 'edit', :id => 1 } to /topics/1/edit" do
    #   route_for(:controller => "topics", :action => "edit", :id => 1).should == "/topics/1/edit"
    # end
    #   
    # it "should map { :controller => 'topics', :action => 'update', :id => 1} to /topics/1" do
    #   route_for(:controller => "topics", :action => "update", :id => 1).should == "/topics/1"
    # end
    #   
    # it "should map { :controller => 'topics', :action => 'destroy', :id => 1} to /topics/1" do
    #   route_for(:controller => "topics", :action => "destroy", :id => 1).should == "/topics/1"
    # end
  end

  describe "route recognition" do

    it "should generate topic params from GET /topic/cat1/cat2" do
      params_from(:get, "/topic/cat1/cat2").should == 
        {:controller => "search", :action => "show", :topic1 => "cat1", :topic2 => "cat2"}
    end

    # it "should generate params { :controller => 'topics', action => 'index' } from GET /topics" do
    #   params_from(:get, "/topics").should == {:controller => "topics", :action => "index"}
    # end
    #   
    # it "should generate params { :controller => 'topics', action => 'new' } from GET /topics/new" do
    #   params_from(:get, "/topics/new").should == {:controller => "topics", :action => "new"}
    # end
    #   
    # it "should generate params { :controller => 'topics', action => 'create' } from POST /topics" do
    #   params_from(:post, "/topics").should == {:controller => "topics", :action => "create"}
    # end
    #   
    # it "should generate params { :controller => 'topics', action => 'show', id => '1' } from GET /topics/1" do
    #   params_from(:get, "/topics/1").should == {:controller => "topics", :action => "show", :id => "1"}
    # end
    #   
    # it "should generate params { :controller => 'topics', action => 'edit', id => '1' } from GET /topics/1;edit" do
    #   params_from(:get, "/topics/1/edit").should == {:controller => "topics", :action => "edit", :id => "1"}
    # end
    #   
    # it "should generate params { :controller => 'topics', action => 'update', id => '1' } from PUT /topics/1" do
    #   params_from(:put, "/topics/1").should == {:controller => "topics", :action => "update", :id => "1"}
    # end
    #   
    # it "should generate params { :controller => 'topics', action => 'destroy', id => '1' } from DELETE /topics/1" do
    #   params_from(:delete, "/topics/1").should == {:controller => "topics", :action => "destroy", :id => "1"}
    # end
  end
end