require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin_sites/new.html.erb" do
  # include Admin::SitesHelper
  
  before(:each) do
    @site = mock_model(Admin::Site)
    @site.stub!(:new_record?).and_return(true)
    assigns[:site] = @site
  end

  # it "should render new form" do
  #   render "admin/sites/new.html.erb"
  #   
  #   response.should have_tag("form[action=?][method=post]", admin_sites_path) do
  #   end
  # end
end


