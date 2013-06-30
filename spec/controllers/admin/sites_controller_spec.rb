require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SitesController do
  fixtures :users

  before(:each) do
    login_as :admin
  end
  
  describe "handling GET /admin_sites" do

    before(:each) do
      @site = mock_model(Site)
      Site.stub!(:find).and_return([@site])
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
  
    it "should find all admin_sites" do
      Site.should_receive(:find).and_return([@site])
      do_get
    end
  
    it "should assign the found admin_sites for the view" do
      do_get
      assigns[:sites].should == [@site]
    end
  end

end