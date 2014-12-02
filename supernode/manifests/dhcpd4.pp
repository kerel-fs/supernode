
# install isc-dhcp-server and configure it to our needs
define supernode::dhcpd4 (
    $ipv4_subnet_start,
    $ipv4_subnet_end,
  ) {

  # FIXME replace by official isc-dhcp-server puppet module?
  
  package { 'isc-dhcp-server':
    ensure  => installed,
  }

  service { 'isc-dhcp-server':
    ensure  => running,
    enable  => true,
    require => [
      Package['isc-dhcp-server'],
      Exec['ifup bat0'],
    ],
  }

  file { 'dhcpd.conf':
    ensure  => file,
    path    => '/etc/dhcp/dhcpd.conf',
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('supernode/dhcpd4/dhcpd.conf.erb'),
    require => Package['isc-dhcp-server'],
    notify  => Service['isc-dhcp-server'],
  }

  file { 'logrotate.d/dhcpd':
    ensure  => file,
    path    => '/etc/logrotate.d/dhcpd',
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => 'puppet:///modules/supernode/dhcpd_logrotate',
    require => Package['logrotate'],
  }
}
