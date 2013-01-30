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

APP_CONFIG = {
  paypal_email: "no-reply@rasohr.com",
  paypal_secret: "_secret_",
  paypal_cert_id: "HGCLQJQ2YE9NA",
  paypal_url: "https://www.paypal.com/cgi-bin/webscr"
}