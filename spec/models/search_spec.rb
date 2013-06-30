require File.dirname(__FILE__) + '/../spec_helper'

describe Search do
  
  describe "parsing DNS queries" do
    it "should set domain_link" do
      search = Search.new({},'ubexactThemeParks.com')
      search.domain_link.should == 'themeparks'
    end
    
    it "should not have domain terms for ubexact.com" do
      search = Search.new({},'ubexact.com')
      search.domain_keyword.should be_nil
      search.domain_topic.should be_nil
      search.domain_keyphrase.should be_nil
    end

    it "should parse domain name for search topic" do
      search = Search.new({},'ubexactTravel.com')
      search.domain_keyword.should be_nil
      search.domain_topic.link_name.should == "travel"
    end
    
    it "should parse domain name for search keyphrase" do
      key_phrase = mock_model(KeyPhrase)
      key_phrase.stub!(:phrase).and_return('Theme Park')
      KeyPhrase.stub!(:find_by_link_name).and_return(key_phrase)
      
      search = Search.new({},'ubexactThemeParks.com')
      search.domain_link.should == 'themeparks'
      search.domain_topic.should be_nil
      search.domain_keyword.should be_nil
      search.domain_keyphrase.phrase.should == "Theme Park"
    end
    
    it "should parse domain name for search keyword" do
      search = Search.new({},'ubexactfoobar.com')
      search.domain_topic.should be_nil
      search.domain_keyphrase.should be_nil
      search.domain_keyword.should == "foobar"
    end

    it "should parse domain name for search msa" do
      s = Search.new({},'ubexactdallasmsa.com')
      s.domain_keyword.should be_nil
      s.domain_msa.should == "dallas"
      s.domain_query?.should_not be_nil
    end
  end
  
  describe "handling DNS queries" do
    before(:each) do
    end
    
    it "should find dns key phrase queries using full text search" do
      Site.should_receive(:full_text_search).and_return([mock_model(Site, :disabled? => false)])
      s = Search.new({},'ubexactThemeParks.com')
      s.execute
    end
    
    it "should find dns topic queries using topic search" do
      topic = mock_model(Topic)
      Topic.stub!(:find).and_return([topic])
      Topic.should_receive(:find).and_return([topic])
      topic.should_receive(:all_sites) 
      s = Search.new({},'ubexactTravel.com')
      s.execute
    end
  
    it "should find dns queries in msa table" do
      @msa = mock_model(MetroServiceArea, :name => 'Dallas')
      MetroServiceArea.stub!(:find).and_return(@msa)
      @msa.should_receive(:metro_service_area_links)
      @msa.should_receive(:sites).and_return([mock_model(Site, :disabled? => false)])
      @msa.should_receive(:children).and_return([mock_model(MetroServiceArea, :name => 'Foo')])
      s = Search.new({},'ubexactdallasmsa.com')
      s.execute
    end
    
  end
  
end