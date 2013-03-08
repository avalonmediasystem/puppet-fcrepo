class fedora::config {
	include staging

	$propfile = "${staging::path}/fedora/installer.properties"
#	$propdir  = "${propfile}.d"
  concat { $propfile: }
#  file   { ["${staging::path}/fedora",$propdir]:
#	  ensure => directory
#  }
}