# capistrano

## Overview

Setup a basic deployment target for the Rails deploy tool capistrano.

Ensures the specific directory structure capistrano expects and sets the right permissions and ownership for everything.

For a more comperhensive Rails deployment recipe which makes use of this module, see [`deversus-rails`](https://forge.puppetlabs.com/deversus/rails).

Requests & patches welcome.

## Usage


```puppet
include capistrano

capistrano::deploytarget {'myapp':
    deploy_user    => 'capistrano',
    share_group    => 'puma',
    deploy_dir     => '/var/www/myapp/',                   # default
    shared_dirs    => ['log', 'tmp', 'public', 'tmp/pids', 'public/system', 'public/assets', 'tmp/cache'], # default
    $cap_version   => 3, # default
}

```

This would create:

- `/var/www/myapp/release` owned by `capistrano`
- `/var/www/myapp/shared` owned by `capistrano` and the group `puma` (your web server will usually need access to this directory), and subdirectories:
    - `/var/www/myapp/shared/log`
    - `/var/www/myapp/shared/tmp/pids`
    - `/var/www/myapp/shared/tmp/cache`
    - `/var/www/myapp/public/system`
    - `/var/www/myapp/public/assets`

Capistrano should run happily the first time using this structure.