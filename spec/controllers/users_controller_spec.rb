require File.dirname(__FILE__) + '/../spec_helper'

# Re-raise errors caught by the controller.
# class UsersController; def rescue_action(e) raise e end; end

describe UsersController do
  integrate_views
  fixtures :users

  it "should allow signup" do
    lambda {
      create_user
    }.should change(User, :count)
    # response.should be_redirect
    response.should render_template('signup_complete')
  end

  it "should require password on signup" do
    lambda {
      create_user(:password => nil)
      assigns(:user).errors.on(:password).should_not be_nil
      response.should be_success
    }.should_not change(User, :count)
  end
  
  it "should require password conirmation on signup" do
    lambda {
      create_user(:password_confirmation => nil)
      assigns(:user).errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    }.should_not change(User, :count)
  end

  it "should require email on signup" do
    lambda {
      create_user(:email => nil)
      assigns(:user).errors.on(:email).should_not be_nil
      response.should be_success
    }.should_not change(User, :count)
  end

  # describe "handling POST /users" do
  #   it "should create associated data (person)" do
  #     lambda {
  #       create_user(:data => {:person => {:first_name => 'Joe', :last_name => 'Schmo' }})
  #     }.should change(User, :count) && change(Person, :count)
  #     assigns(:user).person.first_name.should == 'Joe'
  #   end
  #   
  # end
  
  describe "handling PUT /users/1" do
        
    def do_put
      put :update, :id => 1
    end
  end

  protected  
  def create_user(user_options = {}, other_options = {})
    options = { :user => { :email => 'quire@example.com', 
      :password => 'quirepass', :password_confirmation => 'quirepass' }.merge(user_options) }
    options.merge!(other_options)
    @request.env['HTTPS'] = "on"
    post :create, options
  end
  
end
