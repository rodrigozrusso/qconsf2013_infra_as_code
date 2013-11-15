
package { "mysql-server":
    ensure => installed,
}

file {"/etc/mysql/conf.d/allow_external.cnf":
	owner	=> mysql,
	group	=> mysql,
	mode	=> 0644,
	content => template("/vagrant/allow_external.cnf"),
}

