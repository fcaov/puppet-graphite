# == Class: graphite::params
#
# This class specifies default parameters for the graphite module and SHOULD NOT be called directly.
#
# === Parameters
#
# None.
#
class graphite::params {
	$build_dir = '/usr/local/src/'
	$graphite_var_folder = "/var/esxcloud/graphite"
	$graphiteVersion = 'graphite-web-0.9.10'
	$carbonVersion   = 'carbon-0.9.10'
	$whisperVersion  = 'whisper-0.9.10'


	$whisper_dl_url = "http://launchpad.net/graphite/0.9/0.9.10/+download/${::graphite::params::whisperVersion}.tar.gz"
	$whisper_dl_loc = "${graphite_var_folder}/${whisperVersion}.tar.gz"

	$webapp_dl_url = "http://launchpad.net/graphite/0.9/0.9.10/+download/${::graphite::params::graphiteVersion}.tar.gz"
	$webapp_dl_loc = "${graphite_var_folder}/${graphiteVersion}.tar.gz"

	$carbon_dl_url = "http://launchpad.net/graphite/0.9/0.9.10/+download/${::graphite::params::carbonVersion}.tar.gz"
	$carbon_dl_loc = "${graphite_var_folder}/${carbonVersion}.tar.gz"

	$install_prefix = '/opt/'

	$apache_pkg = $::osfamily ? {
		debian => 'apache2',
		redhat => 'httpd',
	}

	$apache_python_pkg = $::osfamily ? {
		debian => 'libapache2-mod-python',
		redhat => 'mod_python',
	}

	$apache_service_name = $::osfamily ? {
		debian => 'apache2',
		redhat => 'httpd',
	}

	$web_user = $::osfamily ? {
		debian => 'www-data',
		redhat => 'apache',
	}

	$apacheconf_dir = $::osfamily ? {
		debian => '/etc/apache2/sites-available',
		redhat => '/etc/httpd/conf.d',
	}

	$apache_dir = $::osfamily ? {
		debian => '/etc/apache2',
		redhat => '/etc/httpd',
	}

	$graphitepkgs = $::osfamily ? {
		debian => ["python-cairo","python-twisted","python-django","python-django-tagging","python-ldap","python-memcache","python-sqlite","python-simplejson"],
		redhat => ["pycairo",  "python-ldap", "python-memcached", "python-sqlite2",  "bitmap", "bitmap-fonts-compat", "python-devel", "python-crypto", "pyOpenSSL", "gcc", "python-zope-filesystem", "python-zope-interface",  "gcc-c++", "zlib-static", "MySQL-python"],
	}





}
