gem 'tinder', "= 1.8.0"
gem "activesupport", ">= 2.3.4"

require 'tinder'
require "active_support"

class Campfire < CapreseAction
  config_schema({:start_message => String, :stop_message => String, :campfire => {:ssl => Boolean, :domain => String, :room => String, :token => String}})

  def campfire_config
    config[:campfire]
  end

  def campfire
    @campfire ||= (
      campfire = Tinder::Campfire.new(campfire_config[:domain], campfire_config[:token])
      # Use old-style username and password
      # campfire = Tinder::Campfire.new(campfire_config[:domain],
      #                                 :username => campfire_config[:username],
      #                                 :password => campfire_config[:password])
    )
  end

  def room
    @room ||= (campfire.find_room_by_name(campfire_config[:room])) || raise(RuntimeError, "room '#{campfire_config[:room]}' not found.")
  end

  def speak(message)
    message.html_safe!
    room.speak(message)
  end

  def start
    speak config[:start_message]
  end

  def stop
    speak config[:stop_message]
  end
end
