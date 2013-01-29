# == Front Office Controller
#  Front Office Controller for visitors
#  All pages are static
class Public::FrontofficeController < Public::ApplicationController

  # Used to send emails to raso team
	def get_in_touch
    @feedback = Feedback.new(params[:feedback])

    UserMailer.get_in_touch(@feedback).deliver
    flash[:success] = 'Your e-mail was sent to our team'
    redirect_to contacts_path
  end

end
