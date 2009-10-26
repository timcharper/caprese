class Application
  include Appscript
  extend Appscript

  def initialize(name)
    @name = name
  end

  def running?
    ap = app("System Events").application_processes
    (ap[its.short_name.eq(@name)].count(:each => :item) + ap[its.name.eq(@name)].count(:each => :item)) > 0
  end

  def quit!
    handle.quit
  end

  def activate!
    handle.activate
  end

  def handle
    @handle ||= app(@name)
  end

  def path
    "/Applications/#{@name}.app"
  end

  def execpath
    "#{path}/Contents/MacOS"
  end

  def block!
    FileUtils.chmod(000, execpath)
  end

  def unblock!
    FileUtils.chmod(0755, execpath)
  end

  def self.hide_all
    app("System Events").processes[(its.visible.eq(true))].visible.set(false)
  end
end
