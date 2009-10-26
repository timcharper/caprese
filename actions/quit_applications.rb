class QuitApplications < PomodoroAction
  config_schema [String]
  
  def each_target_app
    config.each do |app_config|
      yield(Application.new(app_config))
    end
  end

  def engage
    each_target_app do |application|
      application.quit! if application.running?
    end
  end
end

