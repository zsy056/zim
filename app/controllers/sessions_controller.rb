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
  
  def new
    render :partial => 'new'
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
