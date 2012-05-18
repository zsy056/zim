class MessagesController < ApplicationController
  before_filter :signed_in_user
  
  def create
    to = Integer(params[:message][:to])
    @message = Message.create(:content => params[:message][:content], :from => current_user.id,
      :to => to, :is_sent => ($redis.get(to) != nil))
    @dialog_id = @message.from
    @contact_name = current_user.name
    respond_to do |format|
      if @message.save
        if @message.is_sent
          format.js { render :partial => 'online_msg' }
        else
          @sys_msg = 'Offline message has been sent.'
          format.js { render :partial => 'offline_msg' }
        end
      else
        @sys_msg = 'Offline message failed.'
        format.js { render :partial => 'offline_msg'}
      end
    end
  end

  def new
    respond_to do |format|
      format.js
    end
  end
  
  def index
    @messages = Message.all
  end
end
