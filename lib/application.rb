class Application
  STANDARD_APP_PATHS = ENV["APPS_PATH"].to_s.split(":") + ["/Applications", "/Applications/Utilities", File.join(ENV["HOME"], "applications")]

  include Appscript
  extend Appscript

  attr_reader :name
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

  def path_candidates
    STANDARD_APP_PATHS.map { |app_path| File.join(app_path, "#{@name}.app") }
  end

  def path
    @path ||=
      path_candidates.
      select {|p| File.exist?(p)}.
      first
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

  def exists?
    ! path.nil?
  end

  def to_s
    name
  end
end
