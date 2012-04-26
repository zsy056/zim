class StaticPagesController < ApplicationController
  def home
    @title = 'Home'
  end

  def help
    @title = 'Help'
    respond_to do |format|
      format.js { render :partial => "help" }
    end
  end
end
