# setup tinc backbone connection
define supernode::tinc (
    $hosts_keys_git = 'https://github.com/ff-kbu/bbkeys.git',
  ){
  include supernode

  $supernodenum = $supernode::supernodenum
  $ipv6_addr    = $supernode::ipv6_addr
  $backbone_ip_suffix = $supernode::backbone_ip_suffix

  tinc::server { $name:
    server_name => "fastd${supernodenum}",
    connect_to  => ['Paul', 'Paula'],
    tinc_up     => template('supernode/tinc/tinc-up.erb'),
    subnet      => "Subnet=172.27.255.${backbone_ip_suffix}/32
Subnet=172.27.${ipv4_subnet_start}.0/21
Subnet=fdd3:5d16:b4dd:3::${backbone_ip_suffix}/128
Subnet=2001:67c:20a0:${ipv6_subnet}::/64",
  }~>
  exec { 'tinc/hosts keys':
    command     => "/usr/bin/git clone ${hosts_keys_git} /etc/tinc/backbone/hosts",
    require     => Package['git'],
    refreshonly => true,
  }

  exec { 'routing ffkbu table':
    command => '/bin/echo "200 ffkbu" > /etc/iproute2/rt_tables',
    unless  => '/bin/grep "200 ffkbu" /etc/iproute2/rt_tables',
  }

}
