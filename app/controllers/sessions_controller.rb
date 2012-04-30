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
    uri = URI.parse('http://localhost:9292/im')
    message = {:channel => '/heart_beat', :ext => {:auth_token => FAYE_TOKEN, :id => current_user.id}}
    Net::HTTP.post_form(uri, :message => message.to_json)
    respond_to do |format|
      format.js { render :partial => 'beat' }
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
