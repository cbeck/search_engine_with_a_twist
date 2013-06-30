require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/topics/show.html.erb" do
  include Admin::TopicsHelper
  
  before(:each) do
    @topic = mock_model(Topic)
    @topic.stub!(:name).and_return("MyString")

    assigns[:topic] = @topic
  end

  # it "should render attributes in <p>" do
  #   render "/topics/show.html.erb"
  #   response.should have_text(/MyString/)
  # end
end

