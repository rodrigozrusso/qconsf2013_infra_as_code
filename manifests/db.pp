class mysql {

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

}

include mysql


define opencart_db($database, $username, $password) {
	
	exec { "create-opencart-db":
		command     => "mysqladmin -uroot create opencart",
		unless      => "mysqlshow -uroot opencart",
		path		=> "/usr/bin/",
		require    => Service["mysql"],
	}

	exec { "grant-opencart-user":

		command     => "mysql -uroot -e \"grant all on $database.* to '$username'@'%' identified by '$password';grant all on $database.* to '$username'@'localhost' identified by '$password';\"",
		unless      => "mysql -u$username -p$password",
		path		=> "/usr/bin/",
		require		=> Exec["create-opencart-db"],
	}
}

opencart_db { "opencart-db-parameters":
  database => "opencart",
  username => "openpass",
  password => "openpass",
}
