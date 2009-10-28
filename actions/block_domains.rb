class BlockDomains < CapreseAction
  config_schema({String => Object})

  def start
    config.each do |target_domain, ips|
      Domain.new(target_domain, ips).block
    end
  end
  
  def stop
    IPFW.clear
  end
end

class Domain
  def initialize(name, ips = nil)
    @name = name
    @ips = ips
  end
  
  def ips
    @ips ||= resolve_ips
  end
  
  def resolve_ips
    ips = []
    ips.concat Dig.resolve_ips(@name)
    ips.concat Dig.resolve_ips("www." + @name) unless /^www/.match(@name)
    ips
  end
  
  def block
    ips.each do |ip|
      IPFW.block_ip(ip)
    end
  end
end

class Dig
  def self.resolve_ips(domain)
    %x{dig +short #{domain}}.split("\n").select {|ip| ip.match(/^[0-9.]+/)}
  end
end

class IPFW
  RULESET=6164
  IPFW_BIN="/sbin/ipfw"
  
  def self.run(*args)
    system(IPFW_BIN, *args.map{|a| a.to_s })
  end
  
  def self.block_ip(ip)
    run(*%W[add #{RULESET} deny tcp from any to #{ip}])
  end
  
  def self.clear
    run "delete", RULESET
  end
end
