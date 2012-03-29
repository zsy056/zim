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
    message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://localhost:9292/im")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end
