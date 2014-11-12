class fastd::install () {
  include apt
  package { 'fastd':
    ensure  => installed,
    require => Apt::Source['universe-factory'],
  }
  apt::force { 'libjson-c2':
    release => 'wheezy-backports',
    require => Apt::Source['wheezy-backports'],
  }
}
