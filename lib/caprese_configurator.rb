class CapreseConfigurator
  include ConfigHelpers
  attr_reader :config

  def initialize
    load_config
  end

  def load_config
    @config = []
    load(APP_PATH + 'config.rb')
    @config
  end

  def actions
    config.map do |action_args|
      action, args = action_args
      Object.const_get(action).new(args)
    end
  end

  def load(file)
    eval(File.read(file), binding, file, 1)
  end

  alias require load

  def method_missing(method, *args)
    if /[A-Z]/.match(method.to_s) && Object.const_defined?(method) && Object.const_get(method).ancestors.include?(CapreseAction)
      @config << [method, args]
    else
      super
    end
  end
end