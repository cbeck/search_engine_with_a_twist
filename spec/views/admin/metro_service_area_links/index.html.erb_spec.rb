require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin_metro_service_area_links/index.html.erb" do
  # include Admin::MetroServiceAreaLinksHelper
  
  before(:each) do
    metro_service_area_link_98 = mock_model(MetroServiceAreaLink)
    metro_service_area_link_99 = mock_model(MetroServiceAreaLink)

    assigns[:metro_service_area_links] = [metro_service_area_link_98, metro_service_area_link_99]
  end

  # it "should render list of admin_metro_service_area_links" do
  #   render "admin/metro_service_area_links/index.html.erb"
  # end
end

