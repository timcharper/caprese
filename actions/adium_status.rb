class AdiumStatus < CapreseAction
  include Appscript
  
  config_schema({:away => String, :available => String})

  def start
    return unless running?
    adium_accounts.status_type.set(:away)
    adium_accounts.status_message.set(config[:away])
  end
  
  def stop
    return unless running?
    adium_accounts.status_type.set(:available)
    adium_accounts.status_message.set(config[:available])
  end
  
  def adium_accounts
    @adium_accounts ||= app("Adium").accounts
  end

  def running?
     app("System Events").processes["Adium"].exists
  end
end
