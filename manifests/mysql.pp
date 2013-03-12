class fcrepo::mysql {
  $database     = 'mysql'
  $driver       = 'included'
  $driver_class = 'com.mysql.jdbc.Driver'
  $db_user      = 'vagrant_fc_user'
  $db_pass      = 'vagrant_fc_pwd'
  $jdbc_url     = 'jdbc:mysql://localhost/fedora3?useUnicode=true&amp;characterEncoding=UTF-8&amp;autoReconnect=true'

  include mysql

  class { 'mysql::server':
    config_hash => { 'root_password' => 'vagrant_root_pwd' }
  }
  mysql::db { 'fedora3':
    user     => 'vagrant_fc_user',
    password => 'vagrant_fc_pwd',
    host     => 'localhost',
    grant    => ['all'],
  }
  
  concat::fragment { "fedora-database":
    ensure  => present,
    content => template('fcrepo/fedora_db_properties.erb'),
		target  => $fcrepo::config::propfile
  }
}
