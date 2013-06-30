require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UsersController do
  fixtures :users
  
  before(:each) do
    login_as :admin
  end
  
  it "should use Admin::UsersController" do
    controller.should be_an_instance_of(Admin::UsersController)
  end
  
end
