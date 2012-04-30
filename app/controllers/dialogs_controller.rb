class DialogsController < ApplicationController
  before_filter :signed_in_user
  
  def show
    @dialog_id = params[:id]
    @contact_name = User.find_by_id(@dialog_id).name
    respond_to do |format|
      format.js
    end
  end
end
