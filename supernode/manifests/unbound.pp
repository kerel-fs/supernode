# setup the caching dns server
define supernode::unbound {
  package { 'unbound':
    ensure  => installed,
  }

  file { '/etc/unbound':
    ensure  => directory,
    owner   => root,
    group   => root,
    notify  => File['unbound.conf'],
    require => Package['unbound'],
  }

  file { 'unbound.conf':
    path  => '/etc/unbound/unbound.conf',
    owner => root,
    group => root,
    source=> 'puppet:///modules/supernode/unbound.conf',
  }

  service { 'unbound':
    ensure      => running,
    enable      => true,
    hasstatus   => false,
    hasrestart  => true,
    require     => [
      Package['unbound'],
      File['unbound.conf'],
      Augeas['iface lo post-up'],
      File['/etc/network/interfaces.d/bat0'],
    ],
  }

  augeas { 'iface lo post-up':
    context => '/files/etc/network/interfaces',
    changes => [
      'set iface[. = "lo"]/post-up "ip -6 addr add fdd3:5d16:b5dd::2/128 dev lo"',
    ]
  }
}
