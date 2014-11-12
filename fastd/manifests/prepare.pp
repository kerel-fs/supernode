class fastd::prepare () {
  include apt

  apt::source { 'universe-factory':
    comment   => 'This is the fastd debian repository',
    location  => 'http://repo.universe-factory.net/debian/',
    release   => 'sid',
    repos     => 'main',
    key       => 'CB201D9C',
    key_server => 'pgp.surfnet.nl',
  }

  apt::source { 'wheezy-backports':
    location  => 'http://ftp.debian.org/debian/',
    release   => 'wheezy-backports',
  }
}
