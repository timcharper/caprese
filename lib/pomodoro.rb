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
  
  def self.engage
    $pomodoroName = ARGV[1] || "Pomodoro"
    $duration = (ARGV[2] || 25).to_i

    each_configured_action do |action, args|
      Object.const_get(action).new(args).engage
    end
  end
  
  def self.disengage
    each_configured_action do |action, args|
      Object.const_get(action).new(args).disengage
    end
  end

  def self.method_missing(method, *args)
    if /[A-Z]/.match(method.to_s) && Object.const_defined?(method) && Object.const_get(method).ancestors.include?(PomodoroAction)
      @config << [method, args]
    else
      super
    end
  end
end
