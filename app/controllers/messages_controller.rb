class MessagesController < ApplicationController
  before_filter :signed_in_user
  
  def create
    @message = Message.new do |message|
      message.from = current_user.id
      message.to = Integer(params[:message][:to])
      message.is_sent = ($redis.get(message.to) != nil) 
      message.content = params[:message][:content]
    end
    @dialog_id = @message.from
    @contact_name = current_user.name
    if @message.save
    else
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
