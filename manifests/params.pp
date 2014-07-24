class capistrano::params {
	$deploy_user 		= 'root'
	$share_group 		= undef
	$deploy_dir_spf 	= '/var/www/%s'
	$shared_dirs		= ['log', 'pids', 'system', 'assets']
	$shared_dir_spf		= "$deploy_dir_spf/shared"
	$releases_dir_spf	= "$deploy_dir_spf/releases"
	$default_dir_mode	= 'a+rx,ug+ws'
}