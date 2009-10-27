class PomodoroAction
  attr_reader :config

  def initialize(config)
    self.config = config
    @valid = true
  end

  def self.config_schema(schema)
    @schema = schema
  end

  def self.schema
    @schema
  end

  def schema
    self.class.schema
  end

  def errors
    @errors ||= []
  end

  def valid?
    validate
    @valid
  end

  def start
  end

  def stop
  end

  def validate
    errors.clear
    @valid = true
    validate_schema
  end

  def config=(config)
    if schema == [String]
      @config = unfold_splat(config) { |first_item| first_item.is_a?(Array) }
    else
      @config = unfold_splat(config)
    end
    validate
  end

  private
    def validate_schema
      case
      when schema == [String]
        add_error("config expects an array of strings, got #{@config.inspect}") unless @config.all? { |element| element.is_a?(String) }
      when schema.is_a?(Hash)
        return(add_error("config expects a Hash, got a(n) #{@config.class} instead")) unless @config.is_a?(Hash)

        if schema.keys.first.is_a?(Class)
          key_expectation, value_expectation = schema.keys.first, schema.values.first
          @config.each do |key, value|
            add_error("key #{key.inspect} expected to be of type #{key_expectation}, but is of type #{key.class}") unless key.is_a?(key_expectation)
            add_error("value #{value.inspect} expected to be of type #{value_expectation}, but is of type #{value.class}") unless value.is_a?(value_expectation)
          end
        else
          validate_hash(@config, schema)
        end
      end
    end

    def add_error(message)
      @valid = false
      errors << message
    end

    def unfold_splat(config)
      if config.is_a?(Array) && config.length == 1
        return config if block_given? && (not yield(config.first))
        config.first
      else
        config
      end
    end

    def validate_hash(input, expectation)
      input.each do |key, value|
        next add_error("Unexpected key #{key.inspect} provided. Valid keys here are [#{expectation.keys.map {|k| k.inspect }.sort * ', '}]") unless expectation.has_key?(key)
        case
        when expectation[key].is_a?(Hash)
          next add_error("key #{key.inspect} expects a nested Hash of values, but you provided #{value.inspect}") unless value.is_a?(Hash)
          validate_hash(value, expectation[key])
        when expectation[key].is_a?(Class)
          add_error("key #{key.inspect} expects a value of type #{expectation[key]}, but you provided #{value.inspect} of type #{value.class}") unless value.is_a?(expectation[key])
        else
          puts "Invalid schema: #{expectation[key]}"
        end
      end
    end
end