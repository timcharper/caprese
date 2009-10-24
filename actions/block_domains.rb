class BlockDomains
  def self.engage
    config.each do |target_domain|
      Domain.new(target_domain).block
    end
  end
  
  def self.disengage
    IPFW.clear
  end
  
  def self.config
    YAML.load_file(CONFIG_PATH + "block_domains.yml")
  end
end

class Domain
  def initialize(config)
    @name = config["domain"]
    @config = config
  end
  
  def ips
    @config['ips'] || resolve_ips
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
