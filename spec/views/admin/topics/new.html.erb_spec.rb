require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/topics/new.html.erb" do
  include Admin::TopicsHelper
  
  before(:each) do
    @topic = mock_model(Topic)
    @topic.stub!(:new_record?).and_return(true)
    @topic.stub!(:name).and_return("MyString")
    assigns[:topic] = @topic
  end

  # it "should render new form" do
  #   render "admin/topics/new.html.erb"
  #   
  #   response.should have_tag("form[action=?][method=post]", admin_topics_path) do
  #     with_tag("input#topic_name[name=?]", "topic[name]")
  #   end
  # end
end


