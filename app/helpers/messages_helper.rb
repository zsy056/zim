module MessagesHelper
  def get_offline_msgs
    Message.where(:is_sent => false, :to => current_user.id)
  end
end
