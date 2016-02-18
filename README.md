# haproxy_forwarder

This Module deploys Puppet Haproxy config to provide `port-forwarding`-like Haproxy TCP-proxies

##Usage
Include the class via Hiera oder Manifests
minimal Config via yaml
```yaml
roles:
  - haproxy_forwarder
haproxy_forwarder::backend_port: 22
haproxy_forwarder::frontend_port_range:
  - 1024
  - 1924
```

##Server Config
Haproxy Server Config is not included right now (though its actually little work)
For my usage I use a custom haproxy config and just collect the forwarders via
```
Haproxy_forwarder::Forward <<| |>>
```

### Params
```
$backend_port         = undef
$frontend_port_range  = [1024,1924]
$deploy_frontend      = true,
$deploy_name          = $::fqdn,
$listen_address       = '0.0.0.0',
$backend_address      = $::ipaddress,
```
* `frontend_port_range` required, a range of ports that can be used for dynamic selection. Must be like `lower, higher`, otherwise an error will be thrown.
* `backend_port` required, the port the backend is reachable on.
* `deploy_name` optional, define a custom name for listen/server entries in haproxy. Default :`::fqdn`
* `backend_address`: optional, the ip address of the backend. You may override the default via hiera like `haproxy_forwarder::backend_address: "%{::ipaddress_eth1}"`. Default: `::ipaddress`
* `deploy_frontend`: optional, deploys the listen/server config site for haproxy. Default : true
* `listen_address` : optional, the ip address the haproxy listens on for the given port. Default : 0.0.0.0
