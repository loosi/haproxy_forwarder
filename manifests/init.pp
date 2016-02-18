# Class: haproxy_forwarder
# ===========================
#
# Full description of class haproxy_forwarder here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `deploy_server`
# Boolean Deploy general Haproxy Server, will be added later
#
# * `deploy_frontend`
# Boolean Deploy frontend for haproxy
#
#  * `static_frontend_port`
# Int Port to use as front entry port
# Not implemented right now
#
#  * `backend_port`
# Int Port to use for backend
#
#  * `backend_address`
# IP to use as backend entry
# Actually Haproxy could do a ipv4-ipv6 proxy and reverse,
# but this wont be tested so far
#
#  * `listen_address`
# IP to listen on for the given port in haproxy
#
#  * `frontend_port_range`
# Array of two Integers to use a range for dynamic front port selection
# [ "min", "max"]
#
#  * `deploy_name`
# Name to use for listen/server combination in haproxy
#
# Examples
# --------
#
# @example
#    class { 'haproxy_forwarder':
#      deploy_server => false,
#      ,
#    }
#
# Authors
# -------
#
# Maximilian Rüdiger <loosi@loosi.net>
#
class haproxy_forwarder
(
  Boolean $deploy_server        = false,
  Integer $backend_port         = undef,
  Array   $frontend_port_range  = [],
  Boolean $deploy_frontend      = true,
  String  $deploy_name          = $::fqdn,
  String  $listen_address       = '0.0.0.0',
  String  $backend_address      = $::ipaddress,
  Integer $static_frontend_port = undef,
)
{
  require haproxy_forwarder::validator
  $lowest  = $frontend_port_range[0]
  $highest = $frontend_port_range[1]

  if $::haproxy_forwarder_frontend_port {
    debug ("haproxy_forwarder_frontend_port already exists as a fact")
    $_frontend_port = $::haproxy_forwarder_frontend_port
  }
  else
  {
    $ports_used = query_nodes("haproxy_forwarder_frontend_port>=${lowest} and haproxy_forwarder_frontend_port<=${highest}", 'haproxy_forwarder_frontend_port')
    $unused_port = find_unused_int(sort(concat($ports_used,range(0,$lowest))))
    if $unused_port > $highest {
      warning ( 'Max range for ports reached, not deploying any more ports')
    }
    else {
      file { '/usr/local/puppet_haproxy_forwarder_port' :
        ensure  => present,
        content => "${unused_port}"
      }
    }
    $_frontend_port = $unused_port
  }
  if $deploy_frontend {
    @@haproxy_forwarder::forward { $deploy_name :
      frontend_port     => $_frontend_port,
      backend_port      => $backend_port,
      listen_address    => $listen_address,
      backend_address   => $backend_address,
    }
  }

}
