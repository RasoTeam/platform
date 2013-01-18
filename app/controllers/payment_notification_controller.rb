class PaymentNotificationController < ApplicationController

  protect_from_forgery :except => [:create]

  def create
    if(params[:payment_status] == "Completed")
      bill = Bill.find(params[:invoice])
      bill.state = 1
      bill.paypal_transaction_id = params[:txn_id]
      bill.save
      render :nothing => true
    end
    PaymentNotification.create!(:params => params, :cart_id => params[:invoice], 
      :status => params[:payment_status], :transaction_id => params[:txn_id])
    render :nothing => true
  end

end
