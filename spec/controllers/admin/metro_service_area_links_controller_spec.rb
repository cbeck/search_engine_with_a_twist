require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::MetroServiceAreaLinksController do
  fixtures :users

  before(:each) do
    login_as :admin
  end

  # describe "handling GET /admin/metro_service_area_links" do
  # 
  #   before(:each) do
  #     @metro_service_area_link = mock_model(MetroServiceAreaLink)
  #     MetroServiceAreaLink.stub!(:find).and_return([@metro_service_area_link])
  #   end
  # 
  #   def do_get
  #     get :index
  #   end
  # 
  #   it "should be successful" do
  #     do_get
  #     response.should be_success
  #   end
  # 
  #   it "should render index template" do
  #     do_get
  #     response.should render_template('index')
  #   end
  # 
  #   it "should find all admin_metro_service_area_links" do
  #     MetroServiceAreaLink.should_receive(:find).with(:all).and_return([@metro_service_area_link])
  #     do_get
  #   end
  # 
  #   it "should assign the found admin_metro_service_area_links for the view" do
  #     do_get
  #     assigns[:admin_metro_service_area_links].should == [@metro_service_area_link]
  #   end
  # end

  # describe "handling GET /admin_metro_service_area_links/1" do
  # 
  #   before(:each) do
  #     @metro_service_area_link = mock_model(MetroServiceAreaLink)
  #     MetroServiceAreaLink.stub!(:find).and_return(@metro_service_area_link)
  #   end
  # 
  #   def do_get
  #     get :show, :id => "1"
  #   end
  # 
  #   it "should be successful" do
  #     do_get
  #     response.should be_success
  #   end
  # 
  #   it "should render show template" do
  #     do_get
  #     response.should render_template('show')
  #   end
  # 
  #   it "should find the metro_service_area_link requested" do
  #     MetroServiceAreaLink.should_receive(:find).with("1").and_return(@metro_service_area_link)
  #     do_get
  #   end
  # 
  #   it "should assign the found metro_service_area_link for the view" do
  #     do_get
  #     assigns[:metro_service_area_link].should equal(@metro_service_area_link)
  #   end
  # end

  # describe "handling GET /admin_metro_service_area_links/new" do
  # 
  #   before(:each) do
  #     @metro_service_area = mock_model(MetroServiceArea)
  #     MetroServiceArea.stub!(:find).and_return(@metro_service_area)
  #     @metro_service_area_link = mock_model(MetroServiceAreaLink)
  #     MetroServiceAreaLink.stub!(:new).and_return(@metro_service_area_link)
  #     @metro_service_area_link.should_receive(:metro_service_area=)
  #   end
  # 
  #   def do_get
  #     get :new
  #   end
  # 
  #   it "should be successful" do
  #     do_get
  #     response.should be_success
  #   end
  # 
  #   it "should render new template" do
  #     do_get
  #     response.should render_template('new')
  #   end
  # 
  #   it "should create an new metro_service_area_link" do
  #     MetroServiceAreaLink.should_receive(:new).and_return(@metro_service_area_link)
  #     do_get
  #   end
  # 
  #   it "should not save the new metro_service_area_link" do
  #     @metro_service_area_link.should_not_receive(:save)
  #     do_get
  #   end
  # 
  #   it "should assign the new metro_service_area_link for the view" do
  #     do_get
  #     assigns[:metro_service_area_link].should equal(@metro_service_area_link)
  #   end
  # end
  # 
  # describe "handling GET /admin_metro_service_area_links/1/edit" do
  # 
  #   before(:each) do
  #     @metro_service_area_link = mock_model(MetroServiceAreaLink)
  #     MetroServiceAreaLink.stub!(:find).and_return(@metro_service_area_link)
  #   end
  # 
  #   def do_get
  #     get :edit, :id => "1"
  #   end
  # 
  #   it "should be successful" do
  #     do_get
  #     response.should be_success
  #   end
  # 
  #   it "should render edit template" do
  #     do_get
  #     response.should render_template('edit')
  #   end
  # 
  #   it "should find the metro_service_area_link requested" do
  #     MetroServiceAreaLink.should_receive(:find).and_return(@metro_service_area_link)
  #     do_get
  #   end
  # 
  #   it "should assign the found MetroServiceAreaLink for the view" do
  #     do_get
  #     assigns[:metro_service_area_link].should equal(@metro_service_area_link)
  #   end
  # end
  # 
  # describe "handling POST /admin_metro_service_area_links" do
  # 
  #   before(:each) do
  #     @metro_service_area = mock_model(MetroServiceArea)
  #     @metro_service_area_link = mock_model(MetroServiceAreaLink, :to_param => "1")
  #     MetroServiceAreaLink.stub!(:new).and_return(@metro_service_area_link)
  #     @metro_service_area_link.should_receive(:metro_service_area).and_return(@metro_service_area)
  #   end
  #   
  #   describe "with successful save" do
  # 
  #     def do_post
  #       @metro_service_area_link.should_receive(:save).and_return(true)
  #       post :create, :metro_service_area_link => {}
  #     end
  # 
  #     it "should create a new metro_service_area_link" do
  #       MetroServiceAreaLink.should_receive(:new).with({}).and_return(@metro_service_area_link)
  #       do_post
  #     end
  # 
  #     it "should redirect to the new metro_service_area_link" do
  #       do_post
  #       response.should redirect_to(admin_metro_service_area_url("1"))
  #     end
  #     
  #   end
  #   
  #   describe "with failed save" do
  # 
  #     def do_post
  #       @metro_service_area_link.should_receive(:save).and_return(false)
  #       post :create, :metro_service_area_link => {}
  #     end
  # 
  #     it "should re-render 'new'" do
  #       do_post
  #       response.should render_template('new')
  #     end
  #     
  #   end
  # end
  # 
  # describe "handling PUT /admin/metro_service_area_links/1" do
  # 
  #   before(:each) do
  #     @metro_service_area_link = mock_model(MetroServiceAreaLink, :to_param => "1")
  #     MetroServiceAreaLink.stub!(:find).and_return(@metro_service_area_link)
  #   end
  #   
  #   describe "with successful update" do
  # 
  #     def do_put
  #       @metro_service_area_link.should_receive(:update_attributes).and_return(true)
  #       put :update, :id => "1"
  #     end
  # 
  #     it "should find the metro_service_area_link requested" do
  #       MetroServiceAreaLink.should_receive(:find).with("1").and_return(@metro_service_area_link)
  #       do_put
  #     end
  # 
  #     it "should update the found metro_service_area_link" do
  #       do_put
  #       assigns(:metro_service_area_link).should equal(@metro_service_area_link)
  #     end
  # 
  #     it "should assign the found metro_service_area_link for the view" do
  #       do_put
  #       assigns(:metro_service_area_link).should equal(@metro_service_area_link)
  #     end
  # 
  #     it "should redirect to the metro_service_area_link" do
  #       do_put
  #       response.should redirect_to(admin_metro_service_area_link_url("1"))
  #     end
  # 
  #   end
  #   
  #   describe "with failed update" do
  # 
  #     def do_put
  #       @metro_service_area_link.should_receive(:update_attributes).and_return(false)
  #       put :update, :id => "1"
  #     end
  # 
  #     it "should re-render 'edit'" do
  #       do_put
  #       response.should render_template('edit')
  #     end
  # 
  #   end
  # end
  # 
  # describe "handling DELETE /admin/metro_service_area_links/1" do
  # 
  #   before(:each) do
  #     @metro_service_area_link = mock_model(MetroServiceAreaLink, :destroy => true)
  #     MetroServiceAreaLink.stub!(:find).and_return(@metro_service_area_link)
  #   end
  # 
  #   def do_delete
  #     delete :destroy, :id => "1"
  #   end
  # 
  #   it "should find the metro_service_area_link requested" do
  #     MetroServiceAreaLink.should_receive(:find).with("1").and_return(@metro_service_area_link)
  #     do_delete
  #   end
  # 
  #   it "should call destroy on the found metro_service_area_link" do
  #     @metro_service_area_link.should_receive(:destroy)
  #     do_delete
  #   end
  # 
  #   it "should redirect to the admin_metro_service_area_links list" do
  #     do_delete
  #     response.should redirect_to(admin_metro_service_area_links_url)
  #   end
  # end
end