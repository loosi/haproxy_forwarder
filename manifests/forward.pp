define haproxy_forwarder::forward ( $frontend_port = undef, String $listen_address = undef, Integer $backend_port = undef, String $backend_address = undef)
{
  haproxy::listen { $name :
    ipaddress        => $listen_address,
    ports            => [$frontend_port],
    mode             => 'tcp',
    options   => {
      'option'  => [
        'tcplog',
      ],
    },
  }
  haproxy::balancermember { $name :
    listening_service => $name,
    ports             => [$backend_port],
    server_names      => $name,
    ipaddresses       => $backend_address,
  }
}
