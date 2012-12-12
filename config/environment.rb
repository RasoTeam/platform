# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Platform::Application.initialize!

#Gmail
#config.action_mailer.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 25,
  :domain => "gmail.com",
  :user_name => "no-reply@rasohr.com",
  :password => "r@s0hrt3@m",
  :authentication => "plain",
  :enable_starttls_auto => true
}
