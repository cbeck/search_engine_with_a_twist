class Notifications < ActionMailer::Base  
  
  def signup(user)
    recipients  user.email
    from        NOREPLY_EMAIL
    subject     'Please activate your new account'
    body        :user => user, :url => "http://#{MY_HOST}/activate/#{user.activation_code}"
    # activate_url(user.activation_code)
  end

  def activation(user)
    recipients  user.email
    from        NOREPLY_EMAIL
    subject     'Your account has been activated!'
    body        :user => user
  end

  def forgot_password(user)
    recipients  user.email
    from        NOREPLY_EMAIL
    subject     'Your password change request'
    body        :user => user, :url => "http://#{MY_HOST}/reset_password/#{user.password_reset_code}"
    # reset_password_url(user.activation_code)
  end

  def reset_password(user)
    recipients  user.email
    from        NOREPLY_EMAIL
    subject     'Your password has been reset.'
    body        :user => user
  end
  
  def invite(email, url='http://ubexact.com')
    recipients  email
    from        NOREPLY_EMAIL
    subject     'ubExact '
    body        :url => url
  end

end
