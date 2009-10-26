class BlockApplications < QuitApplications
  def engage
    super
    each_target_app do |application|
      application.block!
    end
  end

  def disengage
    each_target_app do |application|
      application.unblock!
    end
  end
end

