class AdiumStatus
  def self.config
    @config ||= YAML.load_file(CONFIG_PATH + "adium.yml")
  end
  
  def self.engage
    app("Adium").accounts.status_type.set(:away)
    app("Adium").accounts.status_message.set(eval_message('away'))
  end
  
  def self.disengage
    app("Adium").accounts.status_type.set(:available)
    app("Adium").accounts.status_message.set(eval_message('available'))
  end
  
  def self.eval_message(key)
    message = eval("\"#{config[key]}\"")
  end
end