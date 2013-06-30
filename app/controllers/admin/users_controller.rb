class Admin::UsersController < ApplicationController
  before_filter :admin_required, :hide_bookmarks, :set_nav
  def index
    @user_search = params[:user_search]
    conditions = ["email like ?", "%#{@user_search}%"] unless @user_search.nil?
    @users = User.paginate(:all, :conditions => conditions, :order => "email ASC", :page => params[:page])
  end
  
  def show
    @user = User.find params[:id]
  end

  def edit
    @user = User.find params[:id]
  end
  
  def update
    @user = User.find params[:id]

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(admin_users_path) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'There was a problem updating this user.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def suspend
    @user = User.find params[:id]
    @user.active = false
    if @user.save
      flash[:notice] = "#{@user.email} was successfully suspended."
    end
    render :action => 'show'
  end
  
  def activate
    @user = User.find params[:id]
    unless @user.activation_code.nil?
      @user.activation_code = nil
      @user.activated_at = Time.now.utc
    end
    @user.active = true
    if @user.save
      flash[:notice] = "#{@user.email} was activated."
    end
    render :action => 'show'
  end

  def morph
    self.current_user = User.find params[:id]
    redirect_to account_path
  end
end
