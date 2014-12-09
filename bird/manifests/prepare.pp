class bird::prepare {
  include apt

  apt::source { 'wheezy-backports':
    location  => 'http://ftp.debian.org/debian/',
    release   => 'wheezy-backports',
  }
}
