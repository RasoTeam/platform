class CalendarController < ApplicationController
  
  def index
    @company = Company.find( params[:company_id])
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)
    #:conditions => 'some_relations.some_column = true'
    @event_strips = TimeOff.event_strips_for_month(@shown_month, :conditions => "company_id = #{@company.id}")
  end
  
end