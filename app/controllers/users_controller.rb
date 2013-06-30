
class UsersController < ApplicationController
  # ssl_required :create, :new, :edit, :update
  ssl_allowed :create, :new, :edit, :update
  ssl_allowed :forgot_password, :reset_password, :initiate_reset
  before_filter :login_required, 
    :except => [:new, :create, :forgot_password, :reset_password, :initiate_reset, :activate]
  #before_filter :one_column, :only => [:new, :edit]
  before_filter :set_nav, :only => [:new]
  before_filter :hide_bookmarks  
  
  def edit
    @user = current_user
  end

  def new
    @user = User.new
    @user.person = Person.new
  end

  def create   
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        flash[:notice] = 'Thanks for signing up!'
        format.html { render :action => 'signup_complete'} 
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        @show_nav = true
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        @user.reset_password if logged_in? && !@user.password_reset_code.nil?

        format.html { redirect_to(account_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def activate
    self.current_user = User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.activated?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    # redirect_back_or_default('/')
    redirect_to login_url
  end
  
  def invite
    unless params[:email].blank?
      Notifications.deliver_activation(params[:email])
    end
  end
  
  def reset_password
    self.current_user = User.find_by_password_reset_code(params[:password_reset_code])
    flash[:notice] = "You must now change your password!"
    redirect_to(account_url)

    # if logged_in? && !current_user.activated?
    #   current_user.reset_password
    #   flash[:notice] = "Signup complete!"
    # end
    # redirect_back_or_default('/')
  end
  
  def initiate_reset
    if reset_attempt <= 300
      q = params[:email]
      user = User.find_by_email(q)
      if user.nil?
        flash[:notice] = "User #{q} was not found.  (#{reset_attempt.ordinalize} reset attempt)"
        redirect_to(forgot_password_path)
      else
        user.forgot_password
        flash[:notice] = "An activation link has been sent to #{user.email}."
        redirect_to(login_path)
      end
    else
      flash[:notice] = "Too many reset attempts"
      redirect_to(signup_path)
    end
  end  

  protected
  # track the number of reset attempts in a session variable
  def reset_attempt
    if @reset_attempts.nil?
      session['reset_attempt'] ||= 0
      @reset_attempts = session['reset_attempt'] += 1
    end
    @reset_attempts
  end  

end
