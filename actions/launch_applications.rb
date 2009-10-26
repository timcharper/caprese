class LaunchApplications < PomodoroAction
  config_schema [String]
  
  def start
    Application.hide_all
    config.each { |app_name| Application.new(app_name).activate! }
  end
  
  def stop
  end
  
end