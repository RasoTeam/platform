class UserMailer < ActionMailer::Base
  default from: "no-reply@raso.com"

  def verification_email(user)
    @user = user
    mail( :to => user.email, :subject => "Account Confirmation")
  end
end
