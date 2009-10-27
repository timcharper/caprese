class QuitAndBlockApplications < QuitApplications
  def start
    super
    each_target_app do |application|
      application.block!
    end
  end

  def stop
    each_target_app do |application|
      application.unblock!
    end
  end
end

