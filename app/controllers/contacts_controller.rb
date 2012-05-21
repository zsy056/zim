class ContactsController < ApplicationController
  before_filter :signed_in_user
  def create
    @user = User.find(params[:contact][:contact_id])
    current_user.add_contact!(@user)
    redirect_to(@user)
  end

  def destroy
    current_user.rm_contact! Contact.find(params[:id]).contact 
    respond_to do |format|
      @msg = 'Delete success!'
      format.js { render :partial => 'alert' }
    end
  end
  
  def show
    
  end
  
  def index
    @contacts = current_user.contacts.paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.js
      format.html { render :partial => 'index' }
    end
  end

end
