class tinc::install {
  package { 'tinc':
    ensure  => installed,
  }

  file { '/etc/tinc':
    ensure  => directory,
    require => Package['tinc'],
  }

}
