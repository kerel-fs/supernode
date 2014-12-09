class bird::install {
  include apt

  package { 'bird':
    ensure  => installed,
  }

  apt::force { 'bird':
    release => 'wheezy-backports',
    require => Apt::Source['wheezy-backports'],
  }
}
