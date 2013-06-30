require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin_metro_service_area_links/edit.html.erb" do
  # include Admin::MetroServiceAreaLinksHelper
  
  before do
    @metro_service_area_link = mock_model(MetroServiceAreaLink)
    @metro_service_area_link.should_receive(:metro_service_area)
    assigns[:metro_service_area_link] = @metro_service_area_link
  end

  # it "should render edit form" do
  #   render "/admin/metro_service_area_links/edit.html.erb"
  #   
  #   response.should have_tag("form[action=#{admin_metro_service_area_link_path(@metro_service_area_link)}][method=post]") do
  #   end
  # end
end


