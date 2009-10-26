class Pomodoro
  def self.load_config
    @config = []
    config_file = APP_PATH + 'config.rb'
    eval(File.read(config_file), binding, config_file, 1)
    @config
  end

  def self.config
    @config || load_config
  end

  def self.each_configured_action
    config.each do |action_args|
      action, args = action_args
      yield action, args
    end
  end
  
  def self.start
    ENV["POMODORO_DESCRIPTION"] ||= "Pomodoro"
    ENV["POMODORO_DURATION"] ||= "25"

    each_configured_action do |action, args|
      Object.const_get(action).new(args).start
    end
  end
  
  def self.stop
    each_configured_action do |action, args|
      Object.const_get(action).new(args).stop
    end
  end

  def self.method_missing(method, *args)
    if /[A-Z]/.match(method.to_s) && Object.const_defined?(method) && Object.const_get(method).ancestors.include?(PomodoroAction)
      @config << [method, args]
    else
      super
    end
  end

  def self.start_time
    Time.now
  end

  def self.stop_time
    (Time.now + (ENV['POMODORO_DURATION'] || 25).to_i * 60)
  end

  def self.description
    ENV["POMODORO_DESCRIPTION"] || "Pomodoro"
  end
end
