
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
	require    => Package["mysql-server"],
}