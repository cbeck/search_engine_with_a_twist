# require "smtp_tls"

# ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.default_charset = "utf-8"

ActionMailer::Base.smtp_settings = YAML.load_file "#{RAILS_ROOT}/config/mailer.yml"


