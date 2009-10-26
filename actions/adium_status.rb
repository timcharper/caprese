class AdiumStatus < PomodoroAction
  include Appscript
  
  config_schema({:away => String, :available => String})

  def engage
    adium_accounts.status_type.set(:away)
    adium_accounts.status_message.set(config[:away])
  end
  
  def disengage
    adium_accounts.status_type.set(:available)
    adium_accounts.status_message.set(config[:available])
  end
  
  def adium_accounts
    @adium_accounts ||= app("Adium").accounts
  end
end