class PaymentNotificationController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    if(params[:payment_status] == "Completed")
      bill = Bill.find(params[:invoice])
      bill.state = 1
      bill.paypal_transaction_id = params[:txn_id]
      bill.payment_date = Time.now
      puts "\n\n $$$$$$$$$$$$ updating  $$$$$$$$$$\n\n\n"
      puts bill.save
      puts "\n\n $$$$$$$$$$$$ saved  $$$$$$$$$$\n\n\n"
      render :nothing => true
    else
      render :nothing => true
    end
  end

end
