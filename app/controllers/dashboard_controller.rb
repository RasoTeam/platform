class DashboardController < ApplicationController
  def index
  end

  def debug
    @v = params[:val]
    @t = params[:tag]
    @s = params[:get]
    @msg = "whats wrong ?"
    if @v.nil? || @t.nil?
      @msg = "something nil"
    else
      @msg = "COOCKIE CREATED !"
      make_cookie( @v, @t)
    end

    if !@s.nil?
      @cookie = read_cookie( @s) 
    end
  end 
end
