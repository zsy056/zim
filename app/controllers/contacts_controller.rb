class ContactsController < ApplicationController
  before_filter :signed_in_user
  def create
    @user = User.find(params[:contact][:contact_id])
    current_user.add_contact!(@user)
    redirect_to(@user)
  end

  def destroy
    @user = Contact.find(params[:id]).followed
    current_user.rm_contact!(@user)
    redirect_to(@use)
  end
  
  def show
    
  end
  
  def index
    
  end

end
