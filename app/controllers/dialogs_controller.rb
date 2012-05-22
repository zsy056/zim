class DialogsController < ApplicationController
  before_filter :signed_in_user
  
  def show
    @dialog_id = params[:id]
    respond_to do |format|
      format.js { render :partial => 'show' }
    end
  end
end
