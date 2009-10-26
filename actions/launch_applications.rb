class LaunchApplications < PomodoroAction
  config_schema [String]
  
  def engage
    Application.hide_all
    config.each { |app_name| Application.new(app_name).activate! }
  end
  
  def disengage
  end
  
end