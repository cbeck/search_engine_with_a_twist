require File.dirname(__FILE__) + '/../spec_helper'

describe KeyPhrase do
  before(:each) do
    @key_phrase = KeyPhrase.new
  end

  it "should be valid" do
    @key_phrase.should be_valid
  end
  
  it "should count phrase words" do
    phrase = KeyPhrase.new :phrase => 'one two three'
    phrase.words.should == 3
    
    phrase = KeyPhrase.new :phrase => ''
    phrase.words.should == 0
    
    phrase = KeyPhrase.new :phrase => nil
    phrase.words.should == 0
  end
end
