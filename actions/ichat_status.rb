class IchatStatus < CapreseAction
  include Appscript
  
  config_schema({:away => String, :available => String})

  def start
    ichat_accounts.status.set(:away)
    ichat_accounts.status_message.set(config[:away])
  end
  
  def stop
    ichat_accounts.status.set(:available)
    ichat_accounts.status_message.set(config[:available])
  end
  
  def ichat_accounts
    @ichat_accounts ||= app("iChat").services
  end
end