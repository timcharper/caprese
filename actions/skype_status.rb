class SkypeStatus < CapreseAction
  include Appscript

  config_schema({:away => String, :available => String})

  def start
    set_status("dnd")
    set_status_message(config[:away])
  end

  def stop
    set_status("online")
    set_status_message(config[:available])
  end

  def skype
    @skype ||= app("Skype")
  end

  private

  def set_status(status)
    skype.send_(:command => "set userstatus #{status}", :script_name => "caprese")
  end

  def set_status_message(message)
    skype.send_(:command => "set profile mood_text #{message}", :script_name => "caprese")
  end

end
