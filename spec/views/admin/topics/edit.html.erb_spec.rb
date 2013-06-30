require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/topics/edit.html.erb" do
  include Admin::TopicsHelper
  
  before do
    @topic = mock_model(Topic)
    @topic.stub!(:name).and_return("MyString")
    assigns[:topic] = @topic
  end

  # it "should render edit form" do
  #   render "/topics/edit.html.erb"
  #   
  #   response.should have_tag("form[action=#{topic_path(@topic)}][method=post]") do
  #     with_tag('input#topic_name[name=?]', "topic[name]")
  #   end
  # end
end


