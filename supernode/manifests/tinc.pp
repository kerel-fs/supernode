# setup tinc backbone connection
define supernode::tinc (
    $hosts_keys_git = 'https://github.com/ff-kbu/bbkeys.git',
  ){
  include supernode

  $supernodenum = $supernode::supernodenum
  $ipv6_addr    = $supernode::ipv6_addr
  $ipv6_subnet  = $supernode::ipv6_subnet
  $ipv4_subnet_start  = $supernode::ipv4_subnet_start
  $backbone_ip_suffix = $supernode::backbone_ip_suffix
  

  tinc::server { $name:
    server_name => "fastd${supernodenum}",
    connect_to  => ['paul', 'paula'],
    tinc_up     => template('supernode/tinc/tinc-up.erb'),
    subnet      => "Subnet=172.27.255.${backbone_ip_suffix}/32
Subnet=172.27.${ipv4_subnet_start}.0/21
Subnet=fdd3:5d16:b5dd:3::${backbone_ip_suffix}/128
Subnet=2001:67c:20a0:${ipv6_subnet}::/64",
    hosts_git   => "https://github.com/ff-kbu/bbkeys",
  }

  exec { 'routing ffkbu table':
    command => '/bin/echo "200 ffkbu" > /etc/iproute2/rt_tables',
    unless  => '/bin/grep "200 ffkbu" /etc/iproute2/rt_tables',
  }

}
