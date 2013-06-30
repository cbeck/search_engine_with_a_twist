require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/metro_service_areas/new.html.erb" do
  # include Admin::MetroServiceAreasHelper
  
  before(:each) do
    @metro_service_area = mock_model(MetroServiceArea)
    @metro_service_area.stub!(:new_record?).and_return(true)
    @metro_service_area.stub!(:name).and_return("MyString")
    assigns[:metro_service_area] = @metro_service_area
  end

  # it "should render new form" do
  #   render "admin/metro_service_areas/new.html.erb"
  #   
  #   response.should have_tag("form[action=?][method=post]", admin_metro_service_areas_path) do
  #     with_tag("input#metro_service_area_name[name=?]", "metro_service_area[name]")
  #   end
  # end
end


