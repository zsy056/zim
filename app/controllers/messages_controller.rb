class MessagesController < ApplicationController
  before_filter :signed_in_user
  #before_filter :is_contact, only: :index
  
  def create
    to = Integer(params[:message][:to])
    @message = Message.create(:content => params[:message][:content],
                              :from => current_user.id, :to => to,
                              :is_sent => ($redis.get(to) != nil))
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
        @sys_msg = 'Sending message failed.'
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
    cid = params[:contact].to_i
    @messages = Message.where("(`from`=#{current_user.id} AND `to`=#{cid}) OR (`from`=#{cid} AND `to`=#{current_user.id})").order("created_at DESC").all
      .paginate(page: params[:page], per_page: 6)
    respond_to do |format|
      format.js
      format.html { render :partial => 'index' }
    end
  end
  
  private
  
  def is_contact
    redirect_to(root_path) unless current_user.is_contact?(User.find(params[:contact]))
  end
end
