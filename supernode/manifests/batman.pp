# install batman-adv 2013.x (compat 14)
# CAVE: this does not work with backported kernels!
define supernode::batman {
  package { 'batman-adv-dkms':
    ensure  => installed,
    require => Apt::Source['universe-factory'],
  }

  package { 'uml-utilities':
    ensure  => installed,
  }

  $ipv4_start  = $supernode::ipv4_start
  $ipv6_addr   = $supernode::ipv6_addr
  $fastd_iface = $supernode::fastd_iface

  augeas { 'mod-batman':
    context => '/files/etc/modules',
    changes => 'ins batman-adv after *[last()]',
    onlyif  => 'match batman-adv size==0',
    notify  => Exec['modprobe batman'],
    require => Package['batman-adv-dkms'],
  }

  exec { 'modprobe batman':
    command => '/sbin/modprobe batman-adv',
    unless  => '/bin/grep -q batman_adv /proc/modules',
    require => Package['batman-adv-dkms'],
  }

  file { '/etc/network/interfaces.d':
    ensure  => directory,
  }

  Exec['routing ffkbu table']->
  Exec['routing ffkbu6 table']->
  file { '/etc/network/interfaces.d/bat0':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('supernode/batman/bat0.erb'),
    require => File['/etc/network/interfaces.d'],
  }->
  file_line { 'interfaces source dir':
    path  => '/etc/network/interfaces',
    line  => 'source /etc/network/interfaces.d/bat0',
  }~>
  exec { 'ifup bat0':
    command     => '/sbin/ifup bat0',
    refreshonly => true,
  }
}
