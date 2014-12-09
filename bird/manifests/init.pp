class bird {
  class { 'bird::prepare': } ->
  class { 'bird::install': } ->
  class { 'bird::service': } ->
  Class['bird']
}


