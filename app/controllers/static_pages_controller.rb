class StaticPagesController < ApplicationController
  def home
    @title = 'Home'
  end

  def help
    @title = 'Help'
    render :partial => "help"
  end
end
