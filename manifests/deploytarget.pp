# A capistrano deploy location
define capistrano::deploytarget (
	$app_name 		= $title,
	$deploy_user	= $capistrano::deploy_user,
	$share_group	= $capistrano::share_group,
	$deploy_dir 	= sprintf($capistrano::deploy_dir_spf, $title),
	$shared_dirs 	= $capistrano::shared_dirs,
	$symlink_shared_system_dirs = $capistrano::symlink_shared_system_dirs,
	$cap_version = $capistrano::cap_version,
	$shared_dir 	= sprintf($capistrano::shared_dir_spf, $title),
	$releases_dir 	= sprintf($capistrano::releases_dir_spf, $title),
) {

	ensure_resource('user',  $deploy_user, {
		ensure => present,
	})

	if $share_group {
		ensure_resource('group',  $share_group, {
			ensure => present,
		})
	}

	$log_loc = 'log'

	if $cap_version == 3 {
		$pids_loc = 'tmp/pids'
		$cache_loc = 'tmp/cache'
	} else {
		$pids_loc = 'pids'
		$cache_loc = 'cache'
	}

	$nonsystem_shared_dirs = delete(delete(delete($shared_dirs,
										$log_loc), $pids_loc), $cache_loc)



	if $log_loc in $shared_dirs {
		if $symlink_shared_system_dirs {
			$log_dir = "/var/log/$title"
			file {"$shared_dir/$log_loc":
				ensure => link,
				target => $log_dir
			}
		} else {
			$log_dir = "$shared_dir/$log_loc"
		}
	}

	if $pids_loc in $shared_dirs {
		if $symlink_shared_system_dirs {
			# Handled differently as the actual server (puma etc) will also try
			# and manage this location
			$pids_dir = undef
			$_pids_dir = ["/var/$title", "/var/$title/pids"]

			# Specific ownership is best left to the server's manifest
			ensure_resource('file', $_pids_dir, {
				ensure => directory
			})
			file {"$shared_dir/$pids_loc":
				ensure => link,
				target => "/var/$title/pids"
			}
		} else {
			$pids_dir = "$shared_dir/$pids_loc"
		}
	}

	if $cache_loc in $shared_dirs {
		if $symlink_shared_system_dirs {
			$cache_dir = undef
			$_cache_dir = ["/var/$title", "/var/$title/cache"]
			ensure_resource('file', $_cache_dir, {
				ensure => directory
			})

			file {"$shared_dir/$cache_loc":
				ensure => link,
				target => "/var/$title/cache",
			}
		} else {
			$cache_dir = "$shared_dir/$cache_loc"
		}
	}

	$full_shared_dirs = delete_undef_values(concat(
		prefix($nonsystem_shared_dirs, "$shared_dir/"),
		[$log_dir, $pids_dir, $cache_dir]
	))

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
