# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Platform::Application.initialize!

#Gmail
#config.action_mailer.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "gmail.com",
  :user_name => "jonhdeliver@gmail.com",
  :password => "Q1e3t5u7",
  :authentication => "plain",
  :enable_starttls_auto => true
}
