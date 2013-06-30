require File.dirname(__FILE__) + '/../spec_helper'

describe MetroServiceArea do
  before(:each) do
    @metro_service_area = MetroServiceArea.new
  end

  it "should be valid" do
    @metro_service_area.should be_valid
  end
end
