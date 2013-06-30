namespace :ubexact do
  desc "Test Email Send"
  task :notify_test => :environment do    
    user = User.new :email => 'scott@netphase.com'
    Notifications.deliver_activation(user)
  end
  
  task :smtp_test => :environment do
    email = 'scott@netphase.com'
    msg = 'message test'
    
    cfg = ActionMailer::Base.smtp_settings
    puts "Sending message via #{cfg[:address]} to #{email}"
    Net::SMTP.start(cfg[:address], cfg[:port], cfg[:domain], 
      cfg[:user_name], cfg[:password], :plain) do |smtp|
        
        smtp.send_message msg, 'noreply@ubexact.com', email
        
    end
  end
end