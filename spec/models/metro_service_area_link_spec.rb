require File.dirname(__FILE__) + '/../spec_helper'

describe MetroServiceAreaLink do
  before(:each) do
    @metro_service_area_link = MetroServiceAreaLink.new
  end

  it "should be valid" do
    @metro_service_area_link.should be_valid
  end
end
