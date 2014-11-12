# setup the automatic key upload server
define supernode::fastd_web_service(
    $fastd_user,
    $fastd_web_service_auth,
  ) {
  package { [
      'apache2',
      'ruby-sinatra',
      'rubygems',
      'libapache2-mod-passenger',
      'psmisc',
      'sudo',
    ]:
    ensure  => installed,
  }

  package { ['sinatra-contrib', 'netaddr']:
    ensure  => installed,
    provider=> 'gem',
    require => [Package['rubygems'], Package['ruby-sinatra']],
  }

  service { 'apache2':
    ensure  => running,
    enable  => true,
    require => Package['apache2'],
  }

  user { $fastd_user:
    ensure      => present,
    shell       => '/bin/bash',
    home        => "/home/${fastd_user}",
    managehome  => true,
  }

  augeas { 'sudoers':
    context => '/files/etc/sudoers',
    changes => [
      "set spec[user = '${fastd_user}']/user ${fastd_user}",
      "set spec[user = '${fastd_user}']/host_group/host ALL",
      "set spec[user = '${fastd_user}']/host_group/command ALL",
      "set spec[user = '${fastd_user}']/host_group/command/tag NOPASSWD",
    ],
    require => Package['sudo'],
  }

  exec { 'fastd-service':
    command => '/usr/bin/git clone https://github.com/ff-kbu/fastd-service.git /srv/fastd-service',
    creates => '/srv/fastd-service',
    require => Package['git'],
  }

  augeas { 'apache_fastd_service':
    context => '/files/etc/apache2/sites-available/default',
    changes => 'set VirtualHost/*[self::directive = "DocumentRoot"]/arg "/srv/fastd-service/public"',
    require => Package['apache2'],
  }

  file { '/etc/apache2/sites-enabled/default':
    ensure  => 'link',
    target  => '/etc/apache2/sites-available/default',
    require => Augeas['apache_fastd_service'],
  }

  file { 'fastd_web_service conf':
    ensure  => file,
    require => Exec['fastd-service'],
    mode    => '0644',
    path    => '/srv/fastd-service/conf.yml',
    content => template('supernode/fastd_web_service/conf.yml.erb'),
    notify  => Exec['chown fastd-service'],
  }

  exec { 'chown fastd-service':
    command     => "/bin/chown -R ${fastd_user}:${fastd_user} /srv/fastd-service/",
    refreshonly => true,
    require     => [
      File['fastd_web_service conf'],
      User[$fastd_user],
    ],
  }
}
