
package { "mysql-server":
    ensure => installed,
}

file {"/etc/mysql/conf.d/allow_external.cnf":
	owner	=> mysql,
	group	=> mysql,
	mode	=> 0644,
	require => Package["mysql-server"],
	content => template("/vagrant/allow_external.cnf"),
}

