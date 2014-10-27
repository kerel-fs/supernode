class fastd::service {
  service { 'fastd':
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
  }
}
