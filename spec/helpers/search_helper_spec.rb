require File.dirname(__FILE__) + '/../spec_helper'

describe SearchHelper do
  include SearchHelper
  
  before(:each) do
    @topic = Topic.new :name => 'Foo', :link_name => 'foo' 
    @host = "http://test.host"
  end
  
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(SearchHelper)
  end
  
  describe "links with topics" do    
    it "should handle one topic" do
      search = Search.new
      topic_uri(@topic, search).should == "#{@host}/topic/foo"
    end
  
    it "should handle two topics" do
      search = Search.new :topic1 => 'baz'
      topic_uri(@topic, search).should == "#{@host}/topic/baz/foo"
    end

    it "should handle three topics" do
      search = Search.new :topic1 => 'baz', :topic2 => 'bar'
      topic_uri(@topic, search).should == "#{@host}/topic/baz/bar/foo"
    end
  end
  
  describe "links with topics and term" do
    it "should handle one topic with term" do
      search = Search.new :term => 'bar'
      topic_uri(@topic, search).should == "#{@host}/search/bar/topic/foo"
    end
    
    it "should handle two topics with term" do
      search = Search.new({:term => 'bar', :topic1 => 'baz'})
      topic_uri(@topic, search).should == "#{@host}/search/bar/topic/baz/foo"
    end
    
    it "should handle three topics with term" do
      search = Search.new :term => 'bar', :topic1 => 'baz', :topic2 => 'boo'
      topic_uri(@topic, search).should == "#{@host}/search/bar/topic/baz/boo/foo"
    end
  end
  
  describe "links with topic, term and msa" do
    it "should add subtopic to msa domain with term" do
      search = Search.new({:term => 'Banking+Services'}, 'ubexactfloridamsa.com')
      topic_uri(@topic, search).should ==
          "http://ubexactfloridamsa.com/search/Banking+Services/topic/foo"
    end
  end
  
  describe "category links" do
    it "should route to /category/foo" do
      search = Search.new
      category_uri(@topic, search).should == "http://test.host/category/foo"
    end
    
    it "should route to http://ubexacttexasmsa.com/category/foo with msa domain" do
      search = Search.new({}, 'ubexacttexasmsa.com')
      category_uri(@topic, search).should == 'http://ubexacttexasmsa.com/category/foo'
    end
  end
  
  describe "multi-word terms" do
    it "should use + between terms" do
      search = Search.new :term => 'toys games'
      topic_uri(@topic, search).should == "#{@host}/search/toys+games/topic/foo"
    end
  end
  
  describe "handles special domains" do
    it "should use domain if available" do
      search = Search.new({}, 'ubexactbar.com')
      topic_uri(@topic, search).should == "http://ubexactbar.com/topic/foo"
    end
    
    it "should recognize keywords that are domains" do
      search = Search.new
      domain = mock_model(Domain)
      domain.should_receive(:url).and_return "ubexactantiques.com"
      phrase = mock_model(KeyPhrase)
      phrase.should_receive(:domain).and_return domain
      keyphrase_uri(phrase, search).should == {:host => 'ubexactantiques.com' }
    end
    
    it "should not change msa" do
      search = Search.new({}, 'ubexactcharlottemsa.com')
      phrase = mock_model(KeyPhrase)
      phrase.should_receive(:domain).and_return domain = mock_model(Domain)
      phrase.should_receive(:name).and_return 'antiques'
      keyphrase_uri(phrase, search).should == "/search/antiques"
    end
  end
  
end
