# File::      <tt>common/debian.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: fai::common::debian
#
# Specialization class for Debian systems
class fai::common::debian inherits fai::common {

    # Version specific adaptations

    file { "${fai::params::nfsroot_hookdir}/30-patch-initrd":
        ensure  => $fai::ensure,
        owner   => $fai::params::configdir_owner,
        group   => $fai::params::admingroup,
        mode    => $fai::params::hookfile_mode,
        content => template('fai/nfsroot-hooks/patch-initrd.erb'),
        require => File[$fai::params::nfsroot_hookdir]
    }

    if ( $::lsbdistcodename == 'wheezy' ) {

        # Ugly / magical hack (enforced by fai-setup)
        # https://lists.uni-koeln.de/pipermail/linux-fai/2013-January/009899.html
        nfs::server::export { '/srv/nfs4':
            ensure  => $fai::ensure,
            content => "/srv/nfs4  ${::ipaddress}/16(fsid=0,async,ro,no_subtree_check)\n",
            require => [
                        Package['FAI'],
                        File[$fai::configspacedir],
                        File[$fai::nfsrootdir],
                      ]
        }

        # Hack for the delta node (gaia-80)
        file { "${fai::params::nfsroot_hookdir}/20-download-mpt3sas":
            ensure  => $fai::ensure,
            owner   => $fai::params::configdir_owner,
            group   => $fai::params::admingroup,
            mode    => $fai::params::hookfile_mode,
            content => template('fai/nfsroot-hooks/download-mpt3sas.erb'),
            require => File[$fai::params::nfsroot_hookdir]
        }

        # Hack for the Moonshot nodes, requiring newer Mellanox driver than available in Debian7
        file { "${fai::params::nfsroot_hookdir}/21-download-mlx4":
            ensure  => $fai::ensure,
            owner   => $fai::params::configdir_owner,
            group   => $fai::params::admingroup,
            mode    => $fai::params::hookfile_mode,
            content => template('fai/nfsroot-hooks/download-mlx4.erb'),
            require => File[$fai::params::nfsroot_hookdir]
        }

        # Ugly hack, cf debian bug #731244
        # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=731244
        exec { "sed -i 's/root=/root=${::ipaddress}:/' /usr/sbin/fai-chboot":
            path    => '/usr/bin:/usr/sbin:/bin',
            unless  => "grep root=${ipaddress} /usr/sbin/fai-chboot",
            require => Package['FAI']
        }
        # Ugly hack, cf http://blog.gmane.org/gmane.linux.debian.fai/month=20150901
        exec { "sed -i 's/localboot 0/localboot -1/' /usr/sbin/fai-chboot":
            path    => '/usr/bin:/usr/sbin:/bin',
            unless  => "grep 'localboot -1' /usr/sbin/fai-chboot",
            require => Package['FAI']
        }

        apt::source{'fai':
          type         => 'deb',
          uri          => 'http://fai-project.org/download',
          dist         => 'wheezy',
          components   => 'koeln',
          repo_key_url => 'http://fai-project.org/download/074BCDE4.asc'
        } -> Package['FAI']
    }

}
