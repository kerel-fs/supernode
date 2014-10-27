class tinc::service {
  service { 'tinc':
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => false,
  }
}
