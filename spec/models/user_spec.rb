require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  fixtures :users, :people
  
  before(:each) do
    @user = User.new
  end

  # it "should create associated data (location, phones, etc)" do
  #   lambda {
  #     u = users(:basic)
  #     u.person.first_name = 'Jim'
  #     u.save.should be_true
  #   }.should_not change(Location, :count)
  # end
  # 
  # it "should update associated data (location, phones, etc)" do
  #   lambda {
  #     u = users(:basic)
  #     u.person.first_name = 'Jim'
  #     u.save.should be_true
  #   }.should_not change(Location, :count)
  # end
    
  it "should be invalid without login, email and password" do
    @user.should_not be_valid
    @user = users(:basic)
    @user.should be_valid
  end
  
  it "should protect attributes from form hacking (data)" do
    u = users(:basic)
    lambda { 
      u.update_attributes({:id => -1 }) 
    }.should_not change(u, :id)
    # lambda { 
    #   u.update_attributes({:data => {:location => {:id => 999}}})
    # }.should_not change(u, :location)
  end
    
end
