define appdb($database, $username, $password) {
	
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

appdb { "opencart-db-parameters":
  database => "opencart",
  username => "openpass",
  password => "openpass",
}