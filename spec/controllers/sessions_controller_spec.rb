require File.dirname(__FILE__) + '/../spec_helper'

# Re-raise errors caught by the controller.
# class SessionsController; def rescue_action(e) raise e end; end

describe SessionsController do
  integrate_views
  fixtures :users

  before(:each) do
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  it "should login and redirect" do
    @request.env['HTTPS'] = "on"
    post :create, :email => users(:basic).email, :password => 'test' 
    session[:user].should_not be_nil
    response.should be_redirect
  end

  it "should fail login and not redirect" do
    @request.env['HTTPS'] = "on"
    post :create, :email => users(:basic).email, :password => 'bad password'
    session[:user].should be_nil
    response.should be_success
  end

  it "should logout" do
    login_as :basic
    get :destroy
    session[:user].should be_nil
    response.should be_redirect
  end

  it "should remember me" do
    @request.env['HTTPS'] = "on"
    post :create, :email => users(:basic).email, :password => 'test', :remember_me => "1"
    response.cookies["auth_token"].should_not be_nil
  end

  it "should not remember me" do
    post :create, :email => users(:basic).email, :password => 'test', :remember_me => "0"
    response.cookies["auth_token"].should be_nil
  end

  it "should delete token on logout" do
    login_as :basic
    get :destroy
    response.cookies["auth_token"].should == []
  end

  it "should login with cookie" do
    @request.env['HTTPS'] = "on"
    users(:basic).remember_me
    @request.cookies["auth_token"] = cookie_for(:basic)
    get :new
    @controller.send(:logged_in?).should be_true
  end

  it "should fail expired cookie login" do
    users(:basic).remember_me
    users(:basic).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:basic)
    get :new
    assert !@controller.send(:logged_in?)
  end

  it "should fail cookie login" do
    users(:basic).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    assert !@controller.send(:logged_in?)
  end
  
  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
  
end
