require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin_metro_service_area_links/new.html.erb" do
  # include Admin::MetroServiceAreaLinksHelper
  
  before(:each) do
    @metro_service_area_link = mock_model(Admin::MetroServiceAreaLink)
    @metro_service_area_link.stub!(:new_record?).and_return(true)
    assigns[:metro_service_area_link] = @metro_service_area_link
  end

  # it "should render new form" do
  #   render "/admin_metro_service_area_links/new.html.erb"
  #   
  #   response.should have_tag("form[action=?][method=post]", admin_metro_service_area_links_path) do
  #   end
  # end
end


