require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin_sites/index.html.erb" do
  # include Admin::SitesHelper
  
  before(:each) do
    site_98 = mock_model(Admin::Site)
    site_99 = mock_model(Admin::Site)

    assigns[:sites] = [site_98, site_99]
  end

  # it "should render list of admin_sites" do
  #   render "admin/sites/index.html.erb"
  # end
end

