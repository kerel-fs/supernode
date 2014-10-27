define tinc::server (
    $server_name,
    $connect_to,
    $device = '/dev/net/tun',
    $mode = 'router',
    $compression = 9,
    $interface = 'backbone',
    $tinc_up = '',
    $tinc_down = '',
    $subnet = '',
    $key_bits = 4096,
    $hosts_git = '',
  ) {
  include tinc

  Class['tinc::install'] ->
  Tinc::Server[$name] ~>
  Class['tinc::service']

  file { ["/etc/tinc/${interface}", "/etc/tinc/${interface}/hosts"]:
    ensure  => directory,
    require => File['/etc/tinc'],
  }

  exec { "${interface}_nets_boot":
    command  => "/bin/echo \"${interface}\" > /etc/tinc/nets.boot",
    unless    => "/bin/grep ${interface} /etc/tinc/nets.boot",
    require   => File['/etc/tinc'],
  }

  exec { "${interface}_gen_key":
    command => "/usr/sbin/tincd -n ${interface} -K ${key_bits}",
    unless  => "/bin/ls /etc/tinc/${interface}/ | /bin/grep rsa_key.priv",
    require => File["/etc/tinc/${interface}"],
  }

  file { "${interface}/tinc.conf":
    ensure  => file,
    path    => "/etc/tinc/${interface}/tinc.conf",
    content => template('tinc/tinc.conf.erb'),
    require => File["/etc/tinc/${interface}"],
  }

  if $subnet != '' {
    file { "${interface}_subnet":
      ensure  => file,
      path    => "/etc/tinc/${interface}/subnet",
      content => $subnet,
      notify  => Exec["${interface}_concat_subnet"],
    }
  }
  
  if $hosts_git != '' {
    exec { "${interface}/hosts keys":
      command     => "/usr/bin/git clone ${hosts_git} /etc/tinc/${interface}/hosts",
      require     => Package['git'],
      refreshonly => true,
      notify      => Exec["${interface}_concat_subnet"],
    }
  }

  exec { "${interface}_concat_subnet":
    command     => "/bin/cat /etc/tinc/${interface}/subnet /etc/tinc/${interface}/rsa_key.pub > /etc/tinc/${interface}/hosts/${server_name}",
    refreshonly => true,
    require     => File["/etc/tinc/${interface}/hosts"],
  }

  if $tinc_up != '' {
    file { "${interface}/tinc-up":
      ensure  => file,
      mode    => 0744,
      path    => "/etc/tinc/${interface}/tinc-up",
      content => $tinc_up,
    }
  }

  if $tinc_down != '' {
    file { "${interface}/tinc-down":
      ensure  => file,
      mode    => 0744,
      path    => "/etc/tinc/${interface}/tinc-down",
      content => $tinc_down,
    }
  }
}
