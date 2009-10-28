module ConfigHelpers
  def start_time
    Time.now
  end

  def stop_time
    (Time.now + (ENV['POMODORO_DURATION'] || 25).to_i * 60)
  end

  def description
    ENV["POMODORO_DESCRIPTION"]
  end
end