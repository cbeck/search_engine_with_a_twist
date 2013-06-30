require File.dirname(__FILE__) + '/../spec_helper'

describe BlacklistedSite do
  before(:each) do
    @blacklisted_site = BlacklistedSite.new
  end

  it "should be valid" do
    @blacklisted_site.should be_valid
  end
end
