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
}
