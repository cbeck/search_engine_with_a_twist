require File.dirname(__FILE__) + '/../../spec_helper'

describe "/sites/show.html.erb" do
  # include SitesHelper
  
  before(:each) do
    @site = mock_model(Site)
    @site.stub!(:name).and_return("MyString")
    @site.stub!(:url).and_return("MyString")
    @site.stub!(:state).and_return("MyString")
    @site.stub!(:city).and_return("MyString")
    @site.stub!(:free).and_return(false)
    @site.stub!(:registration_required).and_return(false)
    @site.stub!(:description).and_return("MyText")
    @site.stub!(:official).and_return(false)

    assigns[:site] = @site
  end

  # it "should render attributes in <p>" do
  #   render "/sites/show.html.erb"
  #   response.should have_text(/MyString/)
  #   response.should have_text(/MyString/)
  #   response.should have_text(/MyString/)
  #   response.should have_text(/MyString/)
  #   response.should have_text(/als/)
  #   response.should have_text(/als/)
  #   response.should have_text(/MyText/)
  #   response.should have_text(/als/)
  # end
end

