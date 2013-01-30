# == Bills Controller
#  Controller to manage bills in the backoffice
class Backoffice::BillsController < Backoffice::ApplicationController

  # Show a bill
  def show
    @bill = Company.find(params[:company_id]).bills.find(params[:id])
  end

  # Show all bills from a company
  def index
    @company = Company.find(params[:company_id])
    @bills = @company.bills.order("created_at Desc").paginate(:page => params[:page], :per_page => 15) 
  end

  # Show all bills
  def show_all
      @bills = Bill.search(params[:search], params[:order], params[:filt]).paginate(:page => params[:page], :per_page => 15)
  end

  # generate bills to the current month
  def generate_invoices
    companies = Company.all

    companies.each do |company|

      last = company.last_bill
      last ||= company.created_at.prev_month.to_date

      actual = last.next_month.end_of_month

      while actual < Date.today

        counter = 0
        company.users.each do |user|

          if user.role != ROOT
            last_period = user.periods.where("created_at <= :end_of_last_month",{:end_of_last_month => actual}).order("created_at DESC").first
            
            if !last_period.nil?
              unless last_period.state <= STATE[:inactive] && last_period.created_at <= actual.prev_month
                counter+=1
              end
            end
          end

        end

        if counter > 0
          bill = company.bills.build
          bill.value = counter
          bill.state = -1
          bill.month = actual
          bill.save
        end

        company.last_bill = actual
        company.save

        actual = actual.next_month.end_of_month
      end
    end
    
    redirect_to backoffice_bills_path
  end

end
