module ApplicationHelper
  # Return a title on a per-page basis.
  def title
    base_title = "Zim"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def broadcast(channel, &block)
    sendmsg(['/broadcast'])
  end
  
  def sendmsg(channels, &block)
    uri = URI.parse("http://localhost:9292/im")
    for channel in channels
      message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
      Net::HTTP.post_form(uri, :message => message.to_json)
    end
  end
end
