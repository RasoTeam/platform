class PaymentNotificationController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    if(params[:payment_status] == "Completed" && params[:secret] == APP_CONFIG[:paypal_secret])
      bill = Bill.find(params[:invoice])
      bill.state = 1
      bill.paypal_transaction_id = params[:txn_id]
      bill.payment_date = Time.now
      puts bill.save
    elsif (params[:payment_status] == "Pending" && params[:secret] == APP_CONFIG[:paypal_secret])
      bill = Bill.find(params[:invoice])
      bill.state = -2
      bill.save
    end
    render :nothing => true
  end

end