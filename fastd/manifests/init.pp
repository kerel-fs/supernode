class fastd {
  class {'fastd::prepare': } ->
  class {'fastd::install': } ->
  class {'fastd::service': } ->
  Class['fastd']
}
