# connect to icvpn
define supernode::icvpn (
  ){
  include supernode
  
  #TODO: Hier die Dateien bird.conf und bird6.conf erzeugen
  #      und icvpn-scripte laden
  Exec['routing icvpn table']->
  tinc::server { $name:
    server_name => 'koeln1',
    connect_to  => [],
    tinc_up     => template('supernode/icvpn/tinc-up.erb'),
  }->
  bird::server { $name:
    config_file_v4 => template('supernode/bird/bird.conf.fastd3.erb'),
#    config_file_v6 => template('supernode/bird/bird6.conf.erb'),
  }
}
