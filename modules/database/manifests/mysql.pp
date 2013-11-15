class mysql {

	package { "mysql-server":
	    ensure => installed,
	}

	file {"/etc/mysql/conf.d/allow_external.cnf":
		owner	=> mysql,
		group	=> mysql,
		mode	=> 0644,	
		require => Package["mysql-server"],
		content => template("database/etc/mysql/conf.d/allow_external.cnf"),
		notify  => Service["mysql"],
	}

	service { "mysql":
		ensure     => running,
		enable     => true,
		hasstatus  => true,
		hasrestart => true,
		require    => File["/etc/mysql/conf.d/allow_external.cnf"],
	}

}
