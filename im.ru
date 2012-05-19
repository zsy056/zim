require 'faye'
require File.expand_path('../config/initializers/faye_token.rb', __FILE__)
require File.expand_path('../config/initializers/redis.rb', __FILE__)

class ServerAuth
  def incoming(message, callback)
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != FAYE_TOKEN
        message['error'] = 'Invalid authentication token.'
      elsif message['data'] != nil
        $stderr.puts "[#{Time.now.to_s}] from: #{message['from']} to: #{message['channel']} #{message['data']}"
      end
    end
    callback.call(message)
  end
end

class ClientMonitor

  def incoming(message, callback)
    if message['channel'] == '/heart_beat'
      $redis.set message['ext']['id'], "on"
      $stderr.puts "[#{Time.now.to_s}] #{message['ext']['id'].to_s} on"
    elsif message['channel'] == '/leave'
      $redis.del message['ext']['id']
      $stderr.puts "[#{Time.now.to_s}] #{message['ext']['id'].to_s} off"
    end
    callback.call(message)
  end
end

Faye::WebSocket.load_adapter('thin')
faye_server = Faye::RackAdapter.new(:mount => '/im', :timeout => 45)
faye_server.add_extension(ServerAuth.new)
faye_server.add_extension(ClientMonitor.new)
run faye_server
