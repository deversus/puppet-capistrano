class capistrano (
	$deploy_user 		= $capistrano::params::deploy_user,
	$deploy_dir_spf 	= $capistrano::params::deploy_dir_spf,
	$shared_dirs		= $capistrano::params::shared_dirs,
	$shared_dir_spf		= $capistrano::params::shared_dir_spf,
	$releases_dir_spf	= $capistrano::params::releases_dir_spf,
	$default_dir_mode	= $capistrano::params::default_dir_mode,
) inherits capistrano::params {
	$deploy_dir_root = dirname($deploy_dir_spf)
	file {$deploy_dir_root:
		ensure => directory,
		owner => $deploy_user,
		mode => $default_dir_mode,
	}
}