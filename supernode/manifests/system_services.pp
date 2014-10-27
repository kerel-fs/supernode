define supernode::system_services {
  package { ['logrotate', 'rsyslog', 'unattended-upgrades', 'git', 'curl']:
    ensure  => installed,
  }

  # FIXME: müsste sich durch irgendein debian tool setzen lassen
  file { 'APT_Unattended-Upgrade':
    ensure  => file,
    path    => '/etc/apt/apt.conf.d/20auto-upgrades',
    owner   => root,
    group   => root,
    mode    => '0644',
    content => 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
',
  }

  service { 'rsyslog':
    ensure  => running,
    enable  => true,
    require => Package['rsyslog'],
  }

  file { 'rsyslog.conf':
    ensure  => file,
    path    => '/etc/rsyslog.conf',
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/supernode/rsyslog.conf',
    require => Package['rsyslog'],
    notify  => Service['rsyslog'],
  }

  augeas { '/etc/sysctl.conf':
    context => '/files/etc/sysctl.conf',
    changes => [
      'set net.ipv4.ip_forward 1',
      'set net.ipv4.ip_no_pmtu_disc 1',
      'set net.ipv4.route.flush 1',
      'set net.ipv6.conf.all.forwarding 1',
      'set net.ipv6.conf.all.autoconf 0',
      'set net.ipv6.conf.all.accept_ra 0',
      'set net.core.rmem_max 83886080',
      'set net.core.wmem_max 83886080',
      'set net.core.rmem_default 83886080',
      'set net.core.wmem_default 83886080',
    ],
  }
}
