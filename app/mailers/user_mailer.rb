# == User Mailer Helper
#  Used to send emails to the users
class UserMailer < ActionMailer::Base
  default from: "no-reply@rasohr.com"

  # Sends an email to the user to validate email account
  # @param [User] user User information
  def verification_email(user)
    @user = user
    @company = user.company
    mail( :to => user.email, :subject => "Account Confirmation")
  end

  # Sends an email to the user to reset password
  # @param [User] user User information
  def reset_password(user)
    @user = user
    @company = user.company
    mail( :to => user.email, :subject => "Account Confirmation")
  end

  # Sends an email to the user/visitor to confirm feedback message
  # @param [Feedback] feedback Information with the feedback and email address 
  def feedback_mail_notifier(feedback)
    @feedback = feedback
    mail(:to => feedback.email, :subject => "Raso-LeanHR Feedback", :content_type => "text/html")
  end

  # Sends an email to raso team with user comment
  # @param [Feedback] feedback Information with the comment and email address 
  def get_in_touch(feedback)
    @feedback = feedback
    mail(:to => "no-reply@rasohr.com", :subject => "Get in Touch", :content_type => "text/html")
  end
end
