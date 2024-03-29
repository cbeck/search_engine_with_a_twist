require File.dirname(__FILE__) + '/../spec_helper'

describe SitesController do
  fixtures :users
  
  before(:each) do
    login_as :basic
  end
  
  describe "handling GET /sites" do
    it "should not be implemented" do
      lambda {
        get :index
      }.should raise_error
    end
  end

  describe "handling GET /sites/1" do

    before(:each) do
      @site = mock_model(Site)
      Site.stub!(:find).and_return(@site)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the site requested" do
      Site.should_receive(:find).with("1").and_return(@site)
      do_get
    end
  
    it "should assign the found site for the view" do
      do_get
      assigns[:site].should equal(@site)
    end
  end

  describe "handling GET /sites/new" do

    before(:each) do
      @site = mock_model(Site)
      Site.stub!(:new).and_return(@site)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new site" do
      Site.should_receive(:new).and_return(@site)
      do_get
    end
  
    it "should not save the new site" do
      @site.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new site for the view" do
      do_get
      assigns[:site].should equal(@site)
    end
  end

  describe "handling GET /sites/1/edit" do

    before(:each) do
      @site = mock_model(Site)
      Site.stub!(:find).and_return(@site)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the site requested" do
      Site.should_receive(:find).and_return(@site)
      do_get
    end
  
    it "should assign the found Site for the view" do
      do_get
      assigns[:site].should equal(@site)
    end
  end

  describe "handling POST /sites" do

    before(:each) do
      @site = mock_model(Site, :to_param => "1")
      Site.stub!(:new).and_return(@site)
    end
    
    describe "with successful save" do
  
      def do_post
        @site.should_receive(:save).and_return(true)
        @site.should_receive(:disabled?).and_return(false)
        @site.should_receive(:disabled=).with(true)
        @site.should_receive(:user=).with(users(:basic))
        @site.should_receive(:build_key_phrases)
        post :create, :site => {}
      end
  
      it "should create a new site" do
        Site.should_receive(:new).with({}).and_return(@site)
        do_post
      end

      it "should redirect to the new site" do
        do_post
        response.should redirect_to(site_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @site.should_receive(:save).and_return(false)
        @site.should_receive(:disabled?).and_return(false)
        @site.should_receive(:disabled=).with(true)
        @site.should_receive(:user=).with(users(:basic))
        @site.should_receive(:build_key_phrases)
        
        post :create, :site => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /sites/1" do

    before(:each) do
      @site = mock_model(Site, :to_param => "1")
      Site.stub!(:find).and_return(@site)
    end
    
    describe "with successful update" do

      def do_put
        @site.should_receive(:update_attributes).and_return(true)
        @site.should_receive(:build_key_phrases)
        
        put :update, :id => "1", :site => {}
      end

      it "should find the site requested" do
        Site.should_receive(:find).with("1").and_return(@site)
        do_put
      end

      it "should update the found site" do
        do_put
        assigns(:site).should equal(@site)
      end

      it "should assign the found site for the view" do
        do_put
        assigns(:site).should equal(@site)
      end

      it "should redirect to the site" do
        do_put
        response.should redirect_to(site_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @site.should_receive(:update_attributes).and_return(false)
        @site.should_receive(:build_key_phrases)
        put :update, :id => "1", :site => {}
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /sites/1" do

    before(:each) do
      @site = mock_model(Site, :destroy => true)
      Site.stub!(:find).and_return(@site)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the site requested" do
      Site.should_receive(:find).with("1").and_return(@site)
      do_delete
    end
  
    it "should call destroy on the found site" do
      @site.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the sites list" do
      do_delete
      response.should redirect_to(sites_url)
    end
  end
end