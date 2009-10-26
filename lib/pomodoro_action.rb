class PomodoroAction
  attr_reader :config

  def initialize(config)
    self.config = config
  end

  def self.config_schema(schema)
    define_method(:config=) do |config|
      case
      when schema == [String]
        config = unfold_splat(config) { |first_item| first_item.is_a?(Array) }
        @config = config
        unless @config.all? { |element| element.is_a?(String) }
          raise RuntimeError, "#{self.class} expects an array of strings"
        end
      when schema.is_a?(Hash)
        @config = unfold_splat(config)
      else
        @config = unfold_splat(config)
      end
    end
  end

  def unfold_splat(config)
    if config.is_a?(Array) && config.length == 1
      return config if block_given? && (not yield(config.first))
      config.first
    else
      config
    end
  end

  def engage
  end

  def disengage
  end
end