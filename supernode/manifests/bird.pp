# setup bird to connect to icvpn
define supernode::bird (
  ){
  include supernode
  
  #TODO: Hier die Dateien bird.conf und bird6.conf erzeugen
  #      und icvpn-scripte laden
  bird::server { $name:
    config_file_v4 => template('supernode/bird/bird.conf.fastd3.erb'),
#    config_file_v6 => template('supernode/bird/bird6.conf.erb'),
  }
}
