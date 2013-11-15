
package { "mysql-server":
    ensure => installed,
}

file {"/etc/mysql/conf.d/allow_external.cnf":
	owner	=> mysql,
	group	=> mysql,
	mode	=> 0644,	
	require => Package["mysql-server"],
	content => template("/vagrant/allow_external.cnf"),
	notify  => Service["mysql"],
}

service { "mysql":
	ensure     => running,
	enable     => true,
	hasstatus  => true,
	hasrestart => true,
	require    => Package["mysql-server"],
}

exec { "create-opencart-db":
	command     => "mysqladmin -uroot create opencart",
	unless      => "mysqlshow -uroot opencart",
	path		=> "/usr/bin/",
	require    => Service["mysql"],
}

exec { "grant-opencart-user":

	command     => "mysql -uroot -e \"grant all on opencart.* to 'opencart'@'%' identified by 'openpass';grant all on opencart.* to 'opencart'@'localhost' identified by 'openpass';\"",
	unless      => "mysql -uopencart -popenpass",
	path		=> "/usr/bin/",
	require		=> Exec["create-opencart-db"],
}