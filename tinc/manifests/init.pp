class tinc {
  class { 'tinc::install': } ~>
  class { 'tinc::service': } ->
  Class['tinc']
}


