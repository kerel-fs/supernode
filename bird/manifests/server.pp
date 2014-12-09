define bird::server (
   $config_file_v4,
   $config_file_v6,
  ) {

  include bird

  #FIXME: Wird das hier gebraucht (Dup zu init.pp) ?
  Class['bird::install'] ->
  Bird::Server[$name] ~>
  Class['bird::service']

  file { '/etc/bird':
    ensure => directory,
    owner  => root,
    group  => root,
  }

  if $config_file_v4 != '' {
    file { 'bird.conf':
      path  => '/etc/bird/bird.conf',
      owner => root,
      group => root,
      mode  => '0644',
      content => $config_file_v4,
      require => File['/etc/bird'],
    }
  }

  if $config_file_v6 != '' {
    file { 'bird6.conf':
      path  => '/etc/bird/bird6.conf',
      owner => root,
      group => root,
      mode  => '0644',
      content => $config_file_v6,
      require => File['/etc/bird'],
    }
  }
}
