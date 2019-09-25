# File::      <tt>common.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: fai::common
#
# Base class to be inherited by the other fai classes, containing the common code.
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class fai::common {

    # Load the variables used in this module. Check the fai-params.pp file
    require ::fai::params

    # Pre-requisite checks: ensure some services are set
    # TFTP server
    class { '::tftp':
        directory => $fai::tftpdir,
        require   => File[$fai::tftpdir],
    }
    -> class { '::pxelinux':
        ensure   => $fai::ensure,
        root_dir => $fai::tftpdir,
        require  => File[$fai::tftpdir],
    }


    # NFS
    if (! defined( Class['nfs::server'] )) {
        class { '::nfs::server':
            ensure     => $fai::ensure,
            nb_servers => '64',
        }
    }
    # Exports the FAI config space and the NFSROOT by NFS
    nfs::server::export {
        [
        $fai::configspacedir,
        $fai::nfsrootdir,
        ]:
            ensure        => $fai::ensure,
            allowed_hosts => $fai::allowed_clients,
            require       => [
                              Package['FAI'],
                              File[$fai::configspacedir],
                              File[$fai::nfsrootdir],
                              ],
    }


    if $fai::usedebmirror == true {

      # Ensure the local Debmirror is mounted
      exec { "mkdir -p ${fai::debmirror_mountdir}":
          path   => [ '/bin', '/usr/bin' ],
          unless => "test -d ${fai::debmirror_mountdir}",
      }
      mount { $fai::debmirror_mountdir:
          ensure  => 'mounted',
          device  => "${fai::debmirror}:${fai::debmirror_exportdir}",
          atboot  => true,
          fstype  => 'nfs',
          options => 'async,defaults,auto,nfsvers=3,tcp,ro',
          require => Exec["mkdir -p ${fai::debmirror_mountdir}"],
      }
    }
    package { 'FAI':
        ensure  => $fai::ensure,
        name    => $fai::params::packagename,
        #FIXME require => Mount[$fai::debmirror_mountdir],
    }
    package { $fai::params::extra_packages:
        ensure  => $fai::ensure,
        #FIXME require => Mount[$fai::debmirror_mountdir],
    }

    # Create the group
    group { $fai::params::admingroup:
        ensure  => $fai::ensure,
    }
    # If sysadmin::login is configured, make it a member of this group
    if ( defined( Class['sysadmin']) ) {
        # adduser USER GROUP
        exec { "adduser ${sysadmin::login} ${fai::params::admingroup}":
            path    => '/usr/bin:/usr/sbin:/bin',
            require => Group[$fai::params::admingroup],
        }
    }

    # Prepare the binary tools
    if (! defined( File['/root/bin']) ) {
        file { '/root/bin':
            ensure => 'directory',
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
        }
    }

    if $fai::ensure == 'present' {

        # Prepare le different directories
        #/var/log/fai
        file { $fai::params::logdir:
            ensure  => 'directory',
            owner   => $fai::params::logdir_owner,
            group   => $fai::params::logdir_group,
            mode    => $fai::params::logdir_mode,
            require => Package['FAI'],
        }
        # /var/run/fai
        file { $fai::params::piddir:
            ensure  => 'directory',
            owner   => $fai::params::piddir_owner,
            group   => $fai::params::piddir_group,
            mode    => $fai::params::piddir_mode,
            require => Package['FAI'],
        }
        # /etc/fai
        file { $fai::params::configdir:
            ensure  => 'directory',
            owner   => $fai::params::configdir_owner,
            group   => $fai::params::admingroup,
            mode    => $fai::params::configdir_mode,
            require => [
                        Package['FAI'],
                        Group[$fai::params::admingroup]
                        ],
        }
        # /etc/fai/apt
        file { $fai::params::aptdir:
            ensure  => 'directory',
            owner   => $fai::params::configdir_owner,
            group   => $fai::params::admingroup,
            mode    => $fai::params::configdir_mode,
            require => File[$fai::params::configdir],
        }
        # /etc/fai/apt/keys
        file { $fai::params::aptkeysdir:
            ensure       => 'directory',
            owner        => $fai::params::configdir_owner,
            group        => $fai::params::admingroup,
            mode         => $fai::params::configdir_mode,
            recurse      => true,
            recurselimit => 1,
            source       => 'puppet:///modules/fai/apt/keys',
            require      => File[$fai::params::aptdir],
        }



        # /etc/fai/nfsroot_hooks
        file { $fai::params::nfsroot_hookdir:
            ensure  => 'directory',
            owner   => $fai::params::configdir_owner,
            group   => $fai::params::admingroup,
            mode    => $fai::params::configdir_mode,
            # recurse => true,
            # recurselimit => 1,
            # source  => "puppet:///modules/fai/nfsroot-hooks",
            require => [
                        File[$fai::params::configdir],
                        File[$fai::params::nfsroot_configfile]
                        ],
        }
        # /srv/fai/config
        exec { "mkdir -p ${fai::configspacedir}":
            path   => [ '/bin', '/usr/bin' ],
            unless => "test -d ${fai::configspacedir}",
        }
        file { $fai::configspacedir:
            ensure  => 'directory',
            owner   => $fai::params::configdir_owner,
            group   => $fai::params::admingroup,
            mode    => $fai::params::configdir_mode,
            require => [
                        Package['FAI'],
                        Group[$fai::params::admingroup],
                        Exec["mkdir -p ${fai::configspacedir}"]
                        ],
        }
        # /srv/fai/nfsroot
        exec { "mkdir -p ${fai::nfsrootdir}":
            path   => [ '/bin', '/usr/bin' ],
            unless => "test -d ${fai::nfsrootdir}",
        }
        file { $fai::nfsrootdir:
            ensure  => 'directory',
            owner   => $fai::params::configdir_owner,
            group   => $fai::params::admingroup,
            mode    => $fai::params::configdir_mode,
            require => [
                        Package['FAI'],
                        Group[$fai::params::admingroup],
                        Exec["mkdir -p ${fai::nfsrootdir}"]
                        ],
        }
        # /srv/tftp/fai/
        exec { "mkdir -p ${fai::tftpdir}":
            path   => [ '/bin', '/usr/bin' ],
            unless => "test -d ${fai::tftpdir}",
        }
        if (! defined( File[$fai::tftpdir])) {
            file { $fai::tftpdir:
                ensure  => 'directory',
                owner   => $fai::params::configdir_owner,
                group   => $fai::params::admingroup,
                mode    => $fai::params::configdir_mode,
                require => [
                            Package['FAI'],
                            Group[$fai::params::admingroup],
                            Exec["mkdir -p ${fai::tftpdir}"]
                          ],
            }
        }

        # Now prepare the configuration space
        file { "/root/${fai::configspace_provider}":
            ensure => 'directory',
            owner  => $fai::params::configdir_owner,
            group  => $fai::params::admingroup,
            mode   => '0770',
        }

        $repo_path = regsubst($fai::configspace_url, '^.*\/', '')
        vcsrepo { $repo_path:
            ensure   => $fai::params::ensure,
            path     => "/root/${fai::configspace_provider}/${repo_path}",
            source   => $fai::configspace_url,
            provider => $fai::configspace_provider,
            require  => File["/root/${fai::configspace_provider}"],
        }

        # Configure FAI
        file { $fai::params::configfile:
            ensure  => $fai::ensure,
            owner   => $fai::params::configfile_owner,
            group   => $fai::params::configfile_group,
            mode    => $fai::params::configfile_mode,
            content => template('fai/fai.conf.erb'),
            require => File[$fai::params::configdir],
        }
        file { $fai::params::make_nfsroot_configfile:
            ensure  => $fai::ensure,
            owner   => $fai::params::configfile_owner,
            group   => $fai::params::configfile_group,
            mode    => $fai::params::configfile_mode,
            content => template('fai/make-fai-nfsroot.conf.erb'),
            require => File[$fai::params::configdir],
        }
        file { $fai::params::nfsroot_configfile:
            ensure  => $fai::ensure,
            owner   => $fai::params::configfile_owner,
            group   => $fai::params::configfile_group,
            mode    => $fai::params::configfile_mode,
            #source  => "puppet:///modules/fai/NFSROOT",
            content => template('fai/NFSROOT.erb'),
            require => File[$fai::params::configdir],
        }
        file { $fai::params::apt_sources:
            ensure  => $fai::ensure,
            owner   => $fai::params::configfile_owner,
            group   => $fai::params::configfile_group,
            mode    => $fai::params::configfile_mode,
            content => template('fai/apt/sources.list.erb'),
            require => File[$fai::params::configdir],
        }

        file { "${fai::params::nfsroot_hookdir}/10-blacklist-module":
            ensure  => $fai::ensure,
            owner   => $fai::params::configdir_owner,
            group   => $fai::params::admingroup,
            mode    => $fai::params::hookfile_mode,
            content => template('fai/nfsroot-hooks/blacklist-module.erb'),
            require => File[$fai::params::nfsroot_hookdir],
        }

        file { "${fai::params::nfsroot_hookdir}/50-set-tcp-sack":
            ensure  => $fai::ensure,
            owner   => $fai::params::configdir_owner,
            group   => $fai::params::admingroup,
            mode    => $fai::params::hookfile_mode,
            content => template('fai/nfsroot-hooks/set-tcp-sack.erb'),
            require => File[$fai::params::nfsroot_hookdir],
        }

        file { '/root/bin/faiplay':
            ensure  => $fai::ensure,
            group   => $fai::params::admingroup,
            mode    => '0755',
            content => template('fai/faiplay.erb'),
            require => File['/root/bin'],
        }
        file { '/root/bin/ipmiwrapper':
            ensure  => $fai::ensure,
            group   => $fai::params::admingroup,
            mode    => '0755',
            content => template('fai/ipmiwrapper.erb'),
            require => File['/root/bin'],
        }
        file { '/root/bin/update-fai':
            ensure  => $fai::ensure,
            group   => $fai::params::admingroup,
            mode    => '0755',
            content => template('fai/update-fai.erb'),
            require => File['/root/bin'],
        }

#        # ULHPC specific command names
#        if ($::site in [ 'gaia-cluster', 'chaos-cluster', 'nyx-cluster']) {
#            $clustername = regsubst($::site, '/-cluster/', '')
#            file { "/root/bin/${clustername}-ipmi":
#                ensure  => 'link',
#                target  => '/root/bin/ipmiwrapper',
#                require => File['/root/bin/faiplay']
#            }
#
#            file { "/root/bin/${clustername}-update_fai":
#                ensure  => 'link',
#                target  => '/root/bin/update-fai',
#                require => File['/root/bin/faiplay']
#            }
#
#            file { "/root/bin/${clustername}-fai":
#                ensure  => 'link',
#                target  => '/root/bin/faiplay',
#                require => File['/root/bin/faiplay']
#            }
#
#        }

    }
    else
    {
        # Here $fai::ensure is 'absent'

    }

}
