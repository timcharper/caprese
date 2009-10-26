require 'tinder'

class Campfire < PomodoroAction
  config_schema({:start_message => String, :stop_message => String, :campfire => {:domain => String, :room => String, :login => String, :pass => String}})

  def campfire_config
    config[:campfire]
  end

  def campfire
    @campfire ||= (
      campfire = Tinder::Campfire.new(campfire_config[:domain], :ssl => true)
      campfire.login(campfire_config[:login], campfire_config[:pass])
      campfire
    )
  end

  def room
    @room ||= (campfire.find_room_by_name(campfire_config[:room])) || raise(RuntimeError, "room '#{campfire_config[:room]}' not found.")
  end

  def speak(message)
    room.speak(message)
  end

  def start
    room.speak config[:start_message]
  end

  def stop
    room.speak config[:stop_message]
  end
end
