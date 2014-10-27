# setup radvd to our needs
define supernode::radvd ($ipv6_subnet) {
  package { 'radvd':
    ensure  => installed,
  }

  service { 'radvd':
    ensure  => running,
    enable  => true,
    require => Package['radvd']
  }

  file { 'radvd.conf':
    ensure  => file,
    path    => '/etc/radvd.conf',
    content => template('supernode/radvd/radvd.conf.erb'),
    require => Package['radvd'],
    notify  => Service['radvd'],
  }
}
