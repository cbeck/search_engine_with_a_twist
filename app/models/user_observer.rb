class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Notifications.deliver_signup(user)
  end

  def after_save(user) 
    Notifications.deliver_activation(user) if user.recently_activated?
    Notifications.deliver_forgot_password(user) if user.recently_forgot_password?
    Notifications.deliver_reset_password(user) if user.recently_reset_password?    
  end
end