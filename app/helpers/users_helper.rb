module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    size = options[:size]
    image_tag(gravatar(user), alt: user.name, class: "gravatar")
  end
  
  def gravatar(user, options = { size: 50 })
    size = options[:size]
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end
  
  def current_user?(user)
    user == current_user
  end
end
