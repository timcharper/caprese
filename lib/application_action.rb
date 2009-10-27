module ApplicationAction
  def self.included(klass)
    klass.config_schema [String]
  end

  def target_apps
    @target_apps ||= config.map do |app_config|
      Application.new(app_config)
    end
  end

  def validate
    return unless super

    target_apps.each do |application|
      add_error("I can't find application #{application.name} installed in #{application.path}") unless application.exists?
    end
  end
end