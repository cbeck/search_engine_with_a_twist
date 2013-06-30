require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin_metro_service_area_links/show.html.erb" do
  # include Admin::MetroServiceAreaLinksHelper
  
  before(:each) do
    @metro_service_area_link = mock_model(Admin::MetroServiceAreaLink)

    assigns[:metro_service_area_link] = @metro_service_area_link
  end

  # it "should render attributes in <p>" do
  #   render "/admin_metro_service_area_links/show.html.erb"
  # end
end

