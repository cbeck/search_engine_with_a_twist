require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/metro_service_areas/show.html.erb" do
  # include Admin::MetroServiceAreasHelper
  
  before(:each) do
    @metro_service_area = mock_model(MetroServiceArea)
    @metro_service_area.stub!(:name).and_return("MyString")

    assigns[:metro_service_area] = @metro_service_area
  end

  # it "should render attributes in <p>" do
  #   render "admin/metro_service_areas/show.html.erb"
  #   response.should have_text(/MyString/)
  # end
end

