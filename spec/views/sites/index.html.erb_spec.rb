require File.dirname(__FILE__) + '/../../spec_helper'

describe "/sites/index.html.erb" do
  # include SitesHelper
  
  before(:each) do
    site_98 = mock_model(Site)
    site_98.should_receive(:name).and_return("MyString")
    site_98.should_receive(:url).and_return("MyString")
    site_98.should_receive(:state).and_return("MyString")
    site_98.should_receive(:city).and_return("MyString")
    site_98.should_receive(:free).and_return(false)
    site_98.should_receive(:registration_required).and_return(false)
    site_98.should_receive(:description).and_return("MyText")
    site_98.should_receive(:official).and_return(false)
    site_99 = mock_model(Site)
    site_99.should_receive(:name).and_return("MyString")
    site_99.should_receive(:url).and_return("MyString")
    site_99.should_receive(:state).and_return("MyString")
    site_99.should_receive(:city).and_return("MyString")
    site_99.should_receive(:free).and_return(false)
    site_99.should_receive(:registration_required).and_return(false)
    site_99.should_receive(:description).and_return("MyText")
    site_99.should_receive(:official).and_return(false)

    assigns[:sites] = [site_98, site_99]
  end

  # it "should render list of sites" do
  #   render "/sites/index.html.erb"
  #   response.should have_tag("tr>td", "MyString", 2)
  #   response.should have_tag("tr>td", "MyString", 2)
  #   response.should have_tag("tr>td", "MyString", 2)
  #   response.should have_tag("tr>td", "MyString", 2)
  #   # response.should have_tag("tr>td", false, 2)
  #   # response.should have_tag("tr>td", false, 2)
  #   # response.should have_tag("tr>td", "MyText", 2)
  #   # response.should have_tag("tr>td", false, 2)
  # end
end

