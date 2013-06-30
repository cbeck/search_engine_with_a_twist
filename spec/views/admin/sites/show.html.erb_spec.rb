require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sites/show.html.erb" do
  # include Admin::SitesHelper
  
  before(:each) do
    @site = mock_model(Admin::Site)

    assigns[:site] = @site
  end

  # it "should render attributes in <p>" do
  #   render "admin/sites/show.html.erb"
  # end
end

