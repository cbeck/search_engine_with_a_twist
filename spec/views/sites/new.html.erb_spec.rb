require File.dirname(__FILE__) + '/../../spec_helper'

describe "/sites/new.html.erb" do
  # include SitesHelper
  
  before(:each) do
    @site = mock_model(Site)
    @site.stub!(:new_record?).and_return(true)
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

  # it "should render new form" do
  #   render "/sites/new.html.erb"
  #   
  #   response.should have_tag("form[action=?][method=post]", sites_path) do
  #     with_tag("input#site_name[name=?]", "site[name]")
  #     with_tag("input#site_url[name=?]", "site[url]")
  #     with_tag("input#site_state[name=?]", "site[state]")
  #     with_tag("input#site_city[name=?]", "site[city]")
  #     with_tag("input#site_free[name=?]", "site[free]")
  #     with_tag("input#site_registration_required[name=?]", "site[registration_required]")
  #     with_tag("textarea#site_description[name=?]", "site[description]")
  #     with_tag("input#site_official[name=?]", "site[official]")
  #   end
  # end
end


