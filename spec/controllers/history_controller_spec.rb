require File.dirname(__FILE__) + '/../spec_helper'
require 'pp'

describe HistoryController do
  fixtures :topics, :metro_service_areas, :domains
  
  before(:each) do
    # controller.use_rails_error_handling!
    History.destroy_all
  end
  
  it "should pull history" do
    do_history :url => 'http://foobar.com'
    # puts assigns(:history).requests

    assigns(:history).should_not be_nil
    assigns(:history).requests.should_not be_blank
    assigns(:history).requests[0][:url].should == "http://foobar.com"
  end
  
  it "should remember history" do
    do_history :url => 'http://ubexactbar.com'
    pp assigns(:history).requests

    do_history :url => 'http://ubexactbaz.com'
    pp assigns(:history).requests

    assigns(:history).requests.size.should == 2
    assigns(:history).requests[0][:url].should == "http://ubexactbar.com"
    assigns(:history).requests[1][:url].should == "http://ubexactbaz.com"
  end
  
  it "should extract url from domain topic" do
    do_history :url => 'http://ubexactbar.com'
    assigns(:history).requests.should_not be_blank
    assigns(:history).requests[0][:name].should == "ubexactbar.com"
  end

  it "should extract url from demo domain topic" do
    do_history :url => 'http://demo.ubexactbar.com'
    assigns(:history).requests[0][:name].should == "ubexactbar.com"
  end

  
  it "should include extracted keyword" do
    do_history :url => 'http://ubexactartdealer.com', :topics => 'artdealer'
    assigns(:history).requests[0][:name].should == "Art Dealer"
  end
  
  it "should include extracted msa" do
    do_history :url => 'http://ubexactnewyorkmsa.com', :msa => 'newyork'
    assigns(:history).requests[0][:name].should == "New York City"
  end
  
  it "should separate history for each user" do
    do_history :url => 'http://ubexactbar.com'
    assigns(:history).add('http://foobar.com', 'foobar')
    
    puts "*** h = (#{assigns(:history).key}) #{assigns(:history).requests.size}"

    assigns(:history).requests.size.should == 1
    # request.session[:history_key] = nil   # what doesn't this clear the key
    get :destroy
    do_history :url => 'http://ubexactbaz.com'
    assigns(:history).requests.size.should == 1
  end
  
  protected
  def do_history(options = {})
    get :show, options
  end

end
