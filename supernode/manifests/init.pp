# coordinate setup of other classes
class supernode (
    $supernodenum,
    $fastd_key,
    $fastd_web_service_auth
  ) {
  include puppet

  if $supernodenum > 8 {
    fail('Supernodenum not in range 1-8')
  }
  if $supernodenum < 1 {
    fail('Supernodenum not in range 1-8')
  }
  $ipv4_subnets = {
                1 => [0, 7], 2 => [56, 63], 3 => [8, 15], 4 => [16, 23],
                5 => [24, 31], 6 => [32, 39], 7 => [40, 47], 8 => [48, 55]
  }
  $ipv6_subnets = {
                1 => 'b101', 2 => 'b102', 3 => 'b103', 4 => 'b104',
                5 => 'b105', 6 => 'b106', 7 => 'b107', 8 => 'b108'
  }
  $backbone_ip_suffixes = {
                1 => 21, 2 => 22, 3 => 23, 4 => 24,
                5 => 25, 6 => 26, 7 => 27, 8 => 28
  }

  $backbone_keys_git = 'https://github.com/ff-kbu/fastd-pubkeys'

  $fastd_iface = 'mesh-vpn'

  $ipv4_subnet_start  = $ipv4_subnets[ $supernodenum ][0]
  $ipv4_subnet_end    = $ipv4_subnets[ $supernodenum ][1]

  $ipv6_subnet        = $ipv6_subnets[ $supernodenum ]
  $backbone_ip_suffix = $backbone_ip_suffixes[ $supernodenum ]

  $ipv6_addr          = "2001:67c:20a0:${ipv6_subnet}::1"
  $ipv4_start         = "172.27.${ipv4_subnet_start}.1"

  $hostname = "fastd${supernodenum}"

  supernode::system_services{ $hostname: }
  supernode::fastd{ $hostname: }
  supernode::tinc{ $hostname: }
  supernode::batman { $hostname: }
  supernode::fastd_web_service { $hostname: 
    fastd_web_service_auth => $fastd_web_service_auth,
  }
  supernode::dhcpd4 { $hostname:
    ipv4_subnet_start  => $ipv4_subnet_start,
    ipv4_subnet_end    => $ipv4_subnet_end,
  }
  supernode::radvd { $hostname: 
    ipv6_subnet => $ipv6_subnet,
  }
  supernode::nrpe { $hostname :
    backbone_ip_suffix => $backbone_ip_suffix,
  }

  supernode::unbound { $hostname: }
  
}
