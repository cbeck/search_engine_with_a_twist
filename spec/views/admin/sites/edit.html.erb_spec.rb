require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin_sites/edit.html.erb" do
  # include Admin::SitesHelper
  
  before do
    @site = mock_model(Admin::Site)
    assigns[:site] = @site
  end

  # it "should render edit form" do
  #   render "admin/sites/edit.html.erb"
  #   
  #   response.should have_tag("form[action=#{site_path(@site)}][method=post]") do
  #   end
  # end
end


