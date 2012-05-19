module ContactGroupHelper
  def online_status(id)
    if $redis.get(id) == nil
      'offline'
    else
      'online'
    end
  end
end
