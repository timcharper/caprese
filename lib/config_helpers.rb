module ConfigHelpers
  def start_time
    Time.now
  end

  def stop_time
    (Time.now + (ENV['DURATION'] || ENV['POMODORO_DURATION'] || 25).to_i * 60)
  end

  attr_writer :description
  def description
    @description ||= (ENV["DESCRIPTION"] || ENV["POMODORO_DESCRIPTION"]).to_s.dup
  end
end