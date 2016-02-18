# Class: haproxy_forwarder::validator
# ===========================
class haproxy_forwarder::validator(
)
{
  if !empty($haproxy_forwarder::frontend_port_range) {
    validate_integer($haproxy_forwarder::frontend_port_range)
    if $haproxy_forwarder::frontend_port_range[1] < $haproxy_forwarder::frontend_port_range[0] {
      fail{ "haproxy_forwarder_frontend_port_range second value must be greater than the first value, is ${haproxy_forwarder::frontend_port_range[1]} and ${haproxy_forwarder::frontend_port_range[0]}" : }
    }
  }
  else {
    validate_integer($haproxy_forwarder::frontend_port)
  }
  if $haproxy_forwarder::frontend_port_range and $haproxy_forwarder::frontend_port {
    fail { "both frontend_port_range and frontend_port defined, choose one of them" :}
  }
}
