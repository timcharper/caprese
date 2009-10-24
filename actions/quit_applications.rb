class QuitApplications
  class << self
    def config
      @config ||= YAML.load_file(CONFIG_PATH + "applications.yml")
    end
    
    def each_target_app
      config.each do |app_config|
        yield(MacOSXApplication.new(app_config))
      end
    end
  
    def engage
      each_target_app do |application|
        application.quit! if application.running?
        application.block! if application.block?
      end
    end
    
    def disengage
      each_target_app do |application|
        application.unblock!
      end
    end
  end
end

class MacOSXApplication
  def initialize(config)
    @config = config
    @name = config['name']
  end

  def running?
    ap = app("System Events").application_processes
    (ap[its.short_name.eq(@name)].count(:each => :item) + ap[its.name.eq(@name)].count(:each => :item)) > 0
  end

  def quit!
    handle.quit
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

  def block?
    @config['block']
  end
end
