require File.dirname(__FILE__) + '/../spec_helper'

describe Site do
  fixtures :topics, :activities
  
  before(:each) do
    @site = Site.new :activity_id => activities(:see), :topic_id => topics(:art), 
              :url => 'http://foobar.com'
  end

  it "should be valid" do
    @site.should be_valid
  end
end
