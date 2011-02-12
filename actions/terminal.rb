class Terminal < CapreseAction
  include Appscript
  config_schema [String]

  def start
    unless Terminal.caprese_application.running?
      Terminal.caprese_application.activate!
      app = Terminal.caprese_application.handle
      app.do_script(config, :in => app.windows.first)
    end
  end

  def stop
  end

  class << self
    def caprese_application
      @@terminal ||= Application.new("Terminal")
    end
  end

end