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
    ENV["POMODORO_DESCRIPTION"]
    ENV["POMODORO_DURATION"] ||= "25"

    with_growl_notification("start") do
      each_configured_action do |action, args|
        Object.const_get(action).new(args).start
      end
    end
  end
  
  def self.stop
    with_growl_notification("stop") do
      each_configured_action do |action, args|
        Object.const_get(action).new(args).stop
      end
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
    ENV["POMODORO_DESCRIPTION"]
  end

  private
    def self.with_growl_notification(kind, &block)
      begin
        yield
        GrowlHelper.growl("#{APP_NAME} success!", "All #{kind} actions were executed successfully")
      rescue Exception => e
        GrowlHelper.growl("#{APP_NAME} error", "Not all #{kind} actions were completed because this happened:\n#{e.message}")
        raise(e)
      end
    end

end
