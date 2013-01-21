# == Feedback Controller
#  Controllert to manage the feedback actions
class FeedbacksController < ApplicationController
  # Lists all feedback messages
  def index
    @feedbacks = Feedback.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feedbacks }
    end
  end

  # Shows a feedback message
  def show
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feedback }
    end
  end

  # Creates a new feedback message
  def new
    @feedback = Feedback.new
    @feedback.url = params[:url]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedback }
    end
  end

  # Edit a feedback message
  def edit
    @feedback = Feedback.find(params[:id])
  end

  # Creates a feedback message
  def create
    @feedback = Feedback.new(params[:feedback])

    if @feedback.save
        #Send the email with the notification
        UserMailer.feedback_mail_notifier(@feedback).deliver
        redirect_to :back, notice: 'Feedback successfully saved. An e-mail was sent to your mailbox.'
    end
  end

  # Updates a feedback message
  def update
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # Destroyes a feedback message
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to feedbacks_url }
      format.json { head :no_content }
    end
  end
end
