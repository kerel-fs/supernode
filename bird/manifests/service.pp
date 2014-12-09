#Source: https://github.com/sbadia/puppet-bird/blob/master/manifests/init.pp#L99
class bird::service {
  service { 'bird':
    ensure      => running,
    enable      => true,
    hasrestart  => false,
    restart     => '/usr/sbin/birdc configure',
    hasstatus   => false,
  }
}
