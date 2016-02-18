require 'facter'
if File.exists?("/usr/local/puppet_haproxy_forwarder_port")
    port = IO.read("/usr/local/puppet_haproxy_forwarder_port")
end
if port
    Facter.add("haproxy_forwarder_frontend_port") do
      setcode do
        port.to_i
      end
    end
end
