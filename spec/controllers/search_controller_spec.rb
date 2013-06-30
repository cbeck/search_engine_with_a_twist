require File.dirname(__FILE__) + '/../spec_helper'

describe SearchController do
  # fixtures :users

  # before(:each) do
  #   login_as :basic
  # end

  it "should return results on POST" do
    do_search :term =>'travel'
    assigns(:search).should_not be_nil
  end
  
  # it "should reset history on new search" do
  #   session[:history].should be_nil
  #   do_search :term => 'travel'
  #   session[:history].should_not be_empty
  #   get :new
  #   session[:history].should be_empty
  # end
    
  protected
  def do_search(search_options = {})
    options = { :search => {}.merge(search_options) }
    post :create, options  
  end
end
