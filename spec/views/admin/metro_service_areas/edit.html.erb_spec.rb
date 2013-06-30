require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/metro_service_areas/edit.html.erb" do
  # include Admin::MetroServiceAreasHelper
  
  before do
    @metro_service_area = mock_model(MetroServiceArea)
    @metro_service_area.stub!(:name).and_return("MyString")
    assigns[:metro_service_area] = @metro_service_area
  end

  # it "should render edit form" do
  #   render "admin/metro_service_areas/edit.html.erb"
  #   
  #   response.should have_tag("form[action=#{metro_service_area_path(@metro_service_area)}][method=post]") do
  #     with_tag('input#metro_service_area_name[name=?]', "metro_service_area[name]")
  #   end
  # end
end


