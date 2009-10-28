class Pomodoro
  def self.config
    @config = CapreseConfigurator.new
  end

  def self.actions
    config.actions
  end
  
  def self.start
    unless actions_with_errors.empty?
      errors = actions_with_errors.map {|a| "#{a.class}:\n" + format_errors(a.errors) }.join("\n")
      GrowlHelper.growl("#{APP_NAME} config has errors", "Run #{$0} check-config to see all.\n\n#{errors}")
      return false
    end

    with_growl_notification("start") do
      actions.each { |action| action.start }
    end
  end
  
  def self.stop
    with_growl_notification("stop") do
      actions.each { |action| action.stop }
    end
  end

  def self.check_config
    return true if actions_with_errors.empty?

    actions_with_errors.each do |action|
      puts "#{action.class} has errors:\n#{format_errors(action.errors)}"
    end
    false
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

    def self.format_errors(errors)
      "- " + (errors * "\n- ")
    end

    def self.actions_with_errors
      @actions_with_errors ||= actions.select { |a| not a.valid? }
    end
end
