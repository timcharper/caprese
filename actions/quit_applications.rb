class QuitApplications < CapreseAction
  include ApplicationAction

  def start
    target_apps.each do |application|
      application.quit! if application.running?
    end
  end
end

