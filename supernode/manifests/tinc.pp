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
