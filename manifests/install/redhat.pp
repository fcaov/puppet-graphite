# == Class: graphite::install::redhat
#
# This class installs graphite/carbon/whisper on Redhat and its derivates and SHOULD NOT be called directly.
#
# === Parameters
#
# None.
#
class graphite::install::redhat {

	include graphite::params

	Exec { path => '/bin:/usr/bin:/usr/sbin' }

	# for full functionality we need this packages:
	# madatory: python-cairo, python-django, python-twisted, python-django-tagging, python-simplejson
	# optinal: python-ldap, python-memcache, memcached, python-sqlite

	anchor { 'graphitepkg::begin': }
	anchor { 'graphitepkg::end': }

	package { $::graphite::params::graphitepkgs :
		ensure  => installed,
		require => Anchor['graphitepkg::begin'],
		before  => Anchor['graphitepkg::end']
	}

	# Install required python env special for redhat and derivatives

	package { 'python-setuptools':
		ensure  => installed,
		require => Anchor['graphitepkg::begin'],
		before  => Anchor['graphitepkg::end']
	}

	exec {
		'Install django-tagging':
			command => 'pip install django-tagging==0.3.1',
			cwd     => "${::graphite::params::build_dir}",
			require => Anchor['graphitepkg::end'];
		'Install django':
			command => 'pip install django==1.3.1',
			cwd     => "${::graphite::params::build_dir}",
			require => Anchor['graphitepkg::end'];
		'Install twisted':
			command => 'easy_install twisted==13.1',
			cwd     => "${::graphite::params::build_dir}",
			require => Anchor['graphitepkg::end'];
		'Install txamqp':
			command => 'easy_install txamqp',
			cwd     => "${::graphite::params::build_dir}",
			require => Anchor['graphitepkg::end'];
	}

	# Download graphite sources

	exec {
		"Download and untar ${::graphite::params::graphiteVersion}":
			command => "[ -f ${::graphite::params::webapp_dl_loc} ] && tar xzf ${::graphite::params::webapp_dl_loc} || curl -s -L ${::graphite::params::webapp_dl_url} | tar xz",
			creates => "${::graphite::params::build_dir}/${::graphite::params::graphiteVersion}",
			cwd     => "${::graphite::params::build_dir}";
		"Download and untar ${::graphite::params::carbonVersion}":
			command => "[ -f ${::graphite::params::carbon_dl_loc} ] && tar xzf ${::graphite::params::carbon_dl_loc} || curl -s -L ${::graphite::params::carbon_dl_url} | tar xz",
			creates => "${::graphite::params::build_dir}/${::graphite::params::carbonVersion}",
			cwd     => "${::graphite::params::build_dir}";
		"Download and untar ${::graphite::params::whisperVersion}":
			command => "[ -f ${::graphite::params::whisper_dl_loc} ] && tar xzf ${::graphite::params::whisper_dl_loc} || curl -s -L ${::graphite::params::whisper_dl_url} | tar xz",
			creates => "${::graphite::params::build_dir}/${::graphite::params::whisperVersion}",
			cwd     => "${::graphite::params::build_dir}";
	}

	# Install graphite from source

	exec {
		"Install ${::graphite::params::graphiteVersion}":
			command     => 'python setup.py install',
			cwd         => "${::graphite::params::build_dir}/${::graphite::params::graphiteVersion}",
			subscribe   => Exec["Download and untar ${::graphite::params::graphiteVersion}"],
			refreshonly => true,
			require     => [
				Exec["Download and untar ${::graphite::params::graphiteVersion}"],
				Exec["Install django-tagging"]
			];
		"Install ${::graphite::params::carbonVersion}":
			command     => 'python setup.py install',
			cwd         => "${::graphite::params::build_dir}/${::graphite::params::carbonVersion}",
			subscribe   => Exec["Download and untar ${::graphite::params::carbonVersion}"],
			refreshonly => true,
			require     => [
				Exec["Download and untar ${::graphite::params::carbonVersion}"],
				Exec["Install twisted"]
			];
		"Install ${::graphite::params::whisperVersion}":
			command     => 'python setup.py install',
			cwd         => "${::graphite::params::build_dir}/${::graphite::params::whisperVersion}",
			subscribe   => Exec["Download and untar ${::graphite::params::whisperVersion}"],
			refreshonly => true,
			require     => [
				Exec["Download and untar ${::graphite::params::whisperVersion}"],
				Exec["Install twisted"]
			];
	}
}

