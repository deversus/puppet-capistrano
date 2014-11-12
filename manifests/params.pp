class capistrano::params {
  $deploy_user    = 'root'
  $share_group    = undef
  $deploy_dir_spf   = '/var/www/%s'
  $cap2_shared_dirs = ['log', 'pids', 'system', 'assets', 'cache']
  $cap3_shared_dirs = ['log', 'tmp', 'public', 'tmp/pids', 'public/system', 'public/assets', 'tmp/cache']
  $shared_dir_spf   = "$deploy_dir_spf/shared"
  $releases_dir_spf = "$deploy_dir_spf/releases"
  $default_dir_mode = 'a+rx,ug+ws'
  $symlink_shared_system_dirs = true
  $cap_version    = 3
}