class fastd::install () {
  package { 'fastd':
    ensure  => installed,
    require => Augeas['sources_universe'],
  }
}
