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
    mail( :to => user.email, :subject => "Raso Reset Password")
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

  #Send NOTIFICATION email for a new evaluation
  def send_email_new_evaluation(evaluator, evaluatees)
    @names = Array.new
    emails = Array.new
    evaluatees.each do |u|
      @names << u.name
      emails << u.email
    end
    @evaluatorName = evaluator.name
    mail(:to => emails, :subject => "New Evaluation")
  end

  def send_email_new_time_off(request_user,start_date, end_date, managers)
    @user = request_user
    @start_date = start_date
    @end_date = end_date
    managers_emails = Array.new
    managers.each do |m|
      managers_emails << m.email
    end
    mail(:to => managers_emails, :cc => request_user.email, :subject => "Time Off Request")
  end

  def send_email_time_off_result(user, manager, state, start_date, end_date)
    @manager = manager
    @state = state
    @start_date = start_date
    @end_date = end_date
    mail(:to => user.email,  :subject => "Time off" + state)
  end
end
