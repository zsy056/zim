class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:session][:email])
    respond_to do|format|
      if user && user.authenticate(params[:session][:password])
        sign_in user
        format.js
      else
        flash.now[:error] = 'Invalid email/password combination'
        #render :partial => 'new'
        format.js
      end
    end
  end
  
  def beat
    uri = URI.parse(FAYE_SERVER)
    @my_id = current_user.id
    message = {:channel => '/heart_beat', :ext => {:auth_token => FAYE_TOKEN, :id => @my_id}}
    Net::HTTP.post_form(uri, :message => message.to_json)
    @online_msg = 'online'
    @rcontacts = Contact.find_all_by_contact_id(@my_id)
    @online = true
    respond_to do |format|
      format.js { render :partial => 'update_online' }
    end
  end

  def leave
    uri = URI.parse(FAYE_SERVER)
    @my_id = current_user.id
    message = {:channel => '/leave', :ext => {:auth_token => FAYE_TOKEN, :id => @my_id}}
    Net::HTTP.post_form(uri, :message => message.to_json)
    @online_msg = 'offline'
    @rcontacts = Contact.find_all_by_contact_id(@my_id)
    respond_to do |format|
      format.js { render :partial => 'update_online' }
    end
  end
  
  def new
    respond_to do |format|
      format.js { render :partial => 'new' }
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
