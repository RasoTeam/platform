class UserMailer < ActionMailer::Base
  default from: "no-reply@raso.com"

  def verification_email(user)
    @user = user
    mail( :to => user.email, :subject => "Account Confirmation")
  end

  def feedback_mail_notifier(feedback)
    @feedback = feedback
    mail(:to => feedback.email, :subject => "Raso-LeanHR Feedback", :content_type => "text/html")
  end
end
