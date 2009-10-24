class LaunchApplications
  def self.config
    YAML.load_file(CONFIG_PATH + "launch_applications.yml")
  end
  
  def self.engage
    app("System Events").processes[(its.visible.eq(true))].visible.set(false)
    config.each { |app_name| app(app_name).activate }
  end
  
  def self.disengage
  end
  
end