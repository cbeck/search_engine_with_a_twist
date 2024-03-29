require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::BlacklistedSitesController do
  fixtures :users

  before(:each) do
    login_as :admin
  end
  
  describe "handling GET /blacklisted_sites" do

    before(:each) do
      # @blacklisted_site = mock_model(BlacklistedSite)
      @blacklisted_site = BlacklistedSite.new
      BlacklistedSite.stub!(:paginate).and_return([@blacklisted_site])
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all blacklisted_sites" do
      BlacklistedSite.should_receive(:paginate).and_return([@blacklisted_site])
      do_get
    end
  
    it "should assign the found blacklisted_sites for the view" do
      do_get
      assigns[:blacklisted_sites].should == [@blacklisted_site]
    end
  end

  describe "handling GET /blacklisted_sites/1" do

    before(:each) do
      # @blacklisted_site = mock_model(BlacklistedSite)
      @blacklisted_site = BlacklistedSite.new
      BlacklistedSite.stub!(:find).and_return(@blacklisted_site)
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
  
    it "should find the blacklisted_site requested" do
      BlacklistedSite.should_receive(:find).with("1").and_return(@blacklisted_site)
      do_get
    end
  
    it "should assign the found blacklisted_site for the view" do
      do_get
      assigns[:blacklisted_site].should equal(@blacklisted_site)
    end
  end

  describe "handling GET /blacklisted_sites/1.xml" do

    before(:each) do
      @blacklisted_site = mock_model(BlacklistedSite, :to_xml => "XML")
      BlacklistedSite.stub!(:find).and_return(@blacklisted_site)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the blacklisted_site requested" do
      BlacklistedSite.should_receive(:find).with("1").and_return(@blacklisted_site)
      do_get
    end
  
    it "should render the found blacklisted_site as xml" do
      @blacklisted_site.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /blacklisted_sites/new" do

    before(:each) do
      @blacklisted_site = mock_model(BlacklistedSite)
      BlacklistedSite.stub!(:new).and_return(@blacklisted_site)
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
  
    it "should create an new blacklisted_site" do
      BlacklistedSite.should_receive(:new).and_return(@blacklisted_site)
      do_get
    end
  
    it "should not save the new blacklisted_site" do
      @blacklisted_site.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new blacklisted_site for the view" do
      do_get
      assigns[:blacklisted_site].should equal(@blacklisted_site)
    end
  end

  describe "handling GET /blacklisted_sites/1/edit" do

    before(:each) do
      @blacklisted_site = mock_model(BlacklistedSite)
      BlacklistedSite.stub!(:find).and_return(@blacklisted_site)
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
  
    it "should find the blacklisted_site requested" do
      BlacklistedSite.should_receive(:find).and_return(@blacklisted_site)
      do_get
    end
  
    it "should assign the found BlacklistedSite for the view" do
      do_get
      assigns[:blacklisted_site].should equal(@blacklisted_site)
    end
  end

  describe "handling POST /blacklisted_sites" do

    before(:each) do
      @blacklisted_site = mock_model(BlacklistedSite, :to_param => "1")
      BlacklistedSite.stub!(:new).and_return(@blacklisted_site)
    end
    
    describe "with successful save" do
  
      def do_post
        @blacklisted_site.should_receive(:save).and_return(true)
        post :create, :blacklisted_site => {}
      end
  
      it "should create a new blacklisted_site" do
        BlacklistedSite.should_receive(:new).with({}).and_return(@blacklisted_site)
        do_post
      end

      it "should redirect to the new blacklisted_site" do
        do_post
        response.should redirect_to(admin_blacklisted_site_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @blacklisted_site.should_receive(:save).and_return(false)
        post :create, :blacklisted_site => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /blacklisted_sites/1" do

    before(:each) do
      @blacklisted_site = mock_model(BlacklistedSite, :to_param => "1")
      BlacklistedSite.stub!(:find).and_return(@blacklisted_site)
    end
    
    describe "with successful update" do

      def do_put
        @blacklisted_site.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the blacklisted_site requested" do
        BlacklistedSite.should_receive(:find).with("1").and_return(@blacklisted_site)
        do_put
      end

      it "should update the found blacklisted_site" do
        do_put
        assigns(:blacklisted_site).should equal(@blacklisted_site)
      end

      it "should assign the found blacklisted_site for the view" do
        do_put
        assigns(:blacklisted_site).should equal(@blacklisted_site)
      end

      it "should redirect to the blacklisted_site" do
        do_put
        response.should redirect_to(admin_blacklisted_site_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @blacklisted_site.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /blacklisted_sites/1" do

    before(:each) do
      @blacklisted_site = mock_model(BlacklistedSite, :destroy => true)
      BlacklistedSite.stub!(:find).and_return(@blacklisted_site)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the blacklisted_site requested" do
      BlacklistedSite.should_receive(:find).with("1").and_return(@blacklisted_site)
      do_delete
    end
  
    it "should call destroy on the found blacklisted_site" do
      @blacklisted_site.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the blacklisted_sites list" do
      do_delete
      response.should redirect_to(admin_blacklisted_sites_url)
    end
  end
end