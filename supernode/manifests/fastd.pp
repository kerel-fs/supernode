# trigger fastd - vpn installation
define supernode::fastd(
    $backbone_keys_git = 'https://github.com/ff-kbu/fastd-pubkeys',
  ) {

  include supernode

  $supernodenum = $supernode::supernodenum
  $ipv6_addr    = $supernode::ipv6_addr
  $ipv4_start   = $supernode::ipv4_start
  $fastd_key    = $supernode::fastd_key
  $fastd_web_service_auth = $supernode::fastd_web_service_auth

  $interface    = 'mesh-vpn'

  fastd::server{ "fastd${supernodenum}":
    secret_key        => $fastd_key,
    peers_dirs        => ['peers', 'backbone'],
    on_up             => template('supernode/fastd/fastd-up.erb'),
    on_establish      => template('supernode/fastd/on-establish.erb'),
    on_disestablish   => template('supernode/fastd/on-disestablish.erb'),
    ciphers           => ['xsalsa20-poly1305', 'salsa2012+gmac', 'null'],
    secure_handshakes => 'no',
    pmtu              => 'no',
    interface         => $interface,
  } ->
  exec { "${interface}/backbone_keys":
    command => "/usr/bin/git clone ${backbone_keys_git} /etc/fastd/${interface}/backbone",
    creates => "/etc/fastd/${interface}/backbone",
    require => [
      Package['git'],
      File["/etc/fastd/${interface}"],
    ],
  }
}

