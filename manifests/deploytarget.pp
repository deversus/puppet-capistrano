# A capistrano deploy location
define capistrano::deploytarget (
	$app_name 		= $title,
	$deploy_user	= $capistrano::deploy_user,
	$share_group	= $capistrano::share_group,
	$deploy_dir 	= sprintf($capistrano::deploy_dir_spf, $title),
	$shared_dirs 	= $capistrano::shared_dirs,
) {
	$shared_dir 	= sprintf($capistrano::shared_dir_spf, $title)
	$releases_dir 	= sprintf($capistrano::releases_dir_spf, $title)

	ensure_resource('user',  $deploy_user, {
		ensure => present,
	})

	if $share_group {
		ensure_resource('group',  $share_group, {
			ensure => present,
		})
	}


	$full_shared_dirs = prefix($shared_dirs, "$shared_dir/")

	file { [
		$deploy_dir,
		$shared_dir,
		$releases_dir,
		$full_shared_dirs,
	]:
		ensure => directory,
		owner => $deploy_user,
		mode => $capistrano::default_dir_mode,
	}

	if $share_group {
		File[$full_shared_dirs] {
		group => $share_group,
		require => [Group[$share_group]],
	}
	}

}
