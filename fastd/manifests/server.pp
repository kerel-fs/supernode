define create_peers_folder($interface){
  $folder = $name
  file { "${interface}/${folder}":
    ensure  => directory,
    path    => "/etc/fastd/${interface}/${folder}",
    owner   => root,
    group   => root,
    require => File["/etc/fastd/${interface}"],
  }
}

define fastd::server (
    $secret_key,
    $peers_dirs = ['peers'],
    $on_up = '',
    $on_down = '',
    $on_establish = '',
    $on_disestablish = '',
    $on_connect = '', 
    $syslog_level = 'info',
    $interface = 'mesh-vpn',
    $ciphers = ['xsalsa20-poly1305'],
    $secure_handshakes = 'yes',
    $bind_addr = '0.0.0.0:10000',
    $mtu = '1426',
    $pmtu = 'auto',
    $config = '',
  ) {
  require stdlib

  validate_array($peers_dirs, $ciphers)  # from puppetlabs-stdlib

  include fastd
  Class['fastd::install'] ->
  Fastd::Server[$name] ~>
  Class['fastd::service']

  file { '/etc/fastd':
    ensure  => directory,
    owner   => root,
    group   => root,
  }

  file { "/etc/fastd/${interface}":
    ensure  => directory,
    owner   => root,
    group   => root,
    require => File['/etc/fastd'],
  }

  create_peers_folder{$peers_dirs:
    interface   => $interface,
  }

  if $config != '' {
    file { "${interface}/fastd.conf":
      path    => "/etc/fastd/${interface}/fastd.conf",
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $config,
      require => File["/etc/fastd/${interface}"],
    }
  }
  else {
    file { "${interface}/fastd.conf":
      path    => "/etc/fastd/${interface}/fastd.conf",
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('fastd/fastd.conf.erb'),
      require => File["/etc/fastd/${interface}"],
    }
  }

  if $on_up != '' {
    file { "${interface}/fastd-up":
      path    => "/etc/fastd/${interface}/fastd-up",
      owner   => root,
      group   => root,
      mode    => '0755',
      content => $fastd_up,
      require => File["/etc/fastd/${interface}"],
    }
  }

  if $on_down != '' {
    file { "${interface}/fastd-down":
      path    => "/etc/fastd/${interface}/fastd-down",
      owner   => root,
      group   => root,
      mode    => '0755',
      content => $fastd_down,
      require => File["/etc/fastd/${interface}"],
    }
  }

  if $on_establish != '' { 
    file { "${interface}/on-establish":
      path    => "/etc/fastd/${interface}/on-establish",
      owner   => root,
      group   => root,
      mode    => '0755',
      content => $on_establish,
      require => File["/etc/fastd/${interface}"],
    }
  }

  if $on_disestablish != '' {
    file { "${interface}/on-disestablish":
      path    => "/etc/fastd/${interface}/on-disestablish",
      owner   => root,
      group   => root,
      mode    => '0755',
      content => $on_disestablish,
      require => File["/etc/fastd/${interface}"],
    }
  }

  if $on_connect != '' {
    file { "${interface}/on-connect":
      path    => "/etc/fastd/${interface}/on-connect",
      owner   => root,
      group   => root,
      mode    => '0755',
      content => $on_connect,
      require => File["/etc/fastd/${interface}"],
    }
  }

}
