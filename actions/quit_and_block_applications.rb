class QuitAndBlockApplications < CapreseAction
  include ApplicationAction

  def start
    target_apps.each do |application|
      application.quit! if application.running?
      application.block!
    end
  end

  def stop
    target_apps.each do |application|
      application.unblock!
    end
  end
end

