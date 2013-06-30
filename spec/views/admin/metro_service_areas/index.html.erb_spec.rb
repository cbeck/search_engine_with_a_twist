require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/metro_service_areas/index.html.erb" do
  # include Admin::MetroServiceAreasHelper
  
  before(:each) do
    metro_service_area_98 = mock_model(MetroServiceArea)
    metro_service_area_98.should_receive(:name).and_return("MyString")
    metro_service_area_99 = mock_model(MetroServiceArea)
    metro_service_area_99.should_receive(:name).and_return("MyString")

    assigns[:metro_service_areas] = [metro_service_area_98, metro_service_area_99]
  end

  # it "should render list of metro_service_areas" do
  #   render "admin/metro_service_areas/index.html.erb"
  #   response.should have_tag("tr>td", "MyString", 2)
  # end
end

