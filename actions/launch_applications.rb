class LaunchApplications < CapreseAction
  include ApplicationAction
  
  def start
    Application.hide_all
    target_apps.each { |app| app.activate! }
  end
  
  def stop
  end
end