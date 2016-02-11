# File::      <tt>params.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: fai::params
#
# In this class are defined as variables values that are used in other
# fai classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class fai::params {

    ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
    # (Here are set the defaults, provide your custom variables externally)
    # (The default used is in the line with '')
    ###########################################

    # ensure the presence (or absence) of fai
    $ensure = $::fai_ensure ? {
        ''      => 'present',
        default => $::fai_ensure
    }

    # Specification of the hosts which can mount this FAI config space directory
    # via NFS.
    $allowed_clients = $::fai_allowed_clients ? {
        ''      => '*',
        default => $::fai_allowed_clients
    }

    # Account on the install server which saves all log-files and which can
    # change the kernel that is booted via network.
    # Define it, to enable it.
    $loguser = $::fai_loguser ? {
        ''      => '',
        default => $::fai_loguser
    }
    # set protocol type for saving logs. Values: ssh, rsh, ftp
    $logproto = $::fai_logproto ? {
        ''      => 'ssh',
        default => $::fai_logproto
    }

    # How to access the fai config space. For the moment, only svn is supported.
    $configspace_provider = $::fai_configspace_provider ? {
        ''      => 'svn',
        default => $::fai_configspace_provider
    }

    # URL to access the config space
    $configspace_url = $::fai_configspace_provider ? {
        ''      => 'svn.gforge.uni.lu/svn/ulclusters/',
        default => $::fai_configspace_url
    }

    # Hostname (or IP) of the server that provides the Debian mirror via NFS
    $debmirror = $::fai_debmirror ? {
        ''      => 'debmirror',
        default => $::fai_debmirror
    }
    # Export directory *on* the debmirror server that host the Debian mirror
    $debmirror_exportdir = $::fai_debmirror_exportdir ? {
        ''      => '/export/debmirror',
        default => $::fai_debmirror_exportdir
    }
    # Local mount point where the mirror will be mounted
    $debmirror_mountdir = $::fai_debmirror_mountdir ? {
        ''      => '/mnt/debmirror',
        default => $::fai_debmirror_mountdir
    }

    # Suite (i.e.) distribution to be used to generate the FAI NFSroot directory
    # cf make-fai-nfsroot(8)
    $debootstrap_suite = $::fai_debootstrap_suite ? {
        ''      => 'wheezy',
        default => $::fai_debootstrap_suite
    }
    # Options to be passed to debootstrap -- see make-fai-nfsroot(8).
    $debootstrap_opts = $::fai_debootstrap_opts ? {
        ''      => '--include=gnupg --exclude=dhcp-client,info --arch amd64',
        default => $::fai_debootstrap_opts
    }

    # The encrypted (with md5 or crypt) root password on all install clients
    # during installation process; used when log in via ssh.
    # Default password is: fai
    $rootpw_hash = $::fai_rootpw_hash ? {
        ''      => '$1$kBnWcO.E$djxB128U7dMkrltJHPf6d1',
        default => $::fai_rootpw_hash
    }

    # SSH identity file: this user can log to the install clients in as root
    # without a password;
    $ssh_identity = $::fai_ssh_identity ? {
        ''      => '/root/.ssh/id_dsa.pub',
        default => $::fai_ssh_identity
    }

    # The IPMI user set to access the BMC cards on the deployed nodes.
    $ipmiuser = $::fai_ipmiuser ? {
        ''      => 'administrator',
        default => $::fai_ipmiuser
    }

    # Whether or not the backports package should be used
    $use_backports = $::fai_use_backports ? {
        ''      => false,
        default => $::fai_use_backports
    }

    # List of the kernel modules to include in the NFSROOT initrd
    $initramfs_modules = $::fai_initramfs_modules ? {
        ''      => [ 'bnx2' ],
        default => $::fai_initramfs_modules
    }


    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    # fai packages
    $packagename = $::operatingsystem ? {
        default => 'fai-server',
    }
    $extra_packages = $::operatingsystem ? {
        default => [ 'fai-doc' ]
    }
    $admingroup = $::operatingsystem ? {
        default => 'faiadmin'
    }

    # Log directory
    $logdir = $::operatingsystem ? {
        default => '/var/log/fai'
    }
    $logdir_mode = $::operatingsystem ? {
        default => '750',
    }
    $logdir_owner = $::operatingsystem ? {
        default => 'root',
    }
    $logdir_group = $::operatingsystem ? {
        default => 'adm',
    }

    # PID for daemons
    $piddir = $::operatingsystem ? {
        default => '/var/run/fai',
    }
    $piddir_mode = $::operatingsystem ? {
        default => '750',
    }
    $piddir_owner = $::operatingsystem ? {
        default => 'root',
    }
    $piddir_group = $::operatingsystem ? {
        default => $admingroup,
    }

    # Configuration directory & file
    $configdir = $::operatingsystem ? {
        default => '/etc/fai',
    }
    # APT directory
    $aptdir = $::operatingsystem ? {
        default => "${fai::params::configdir}/apt",
    }
    $aptkeysdir = $::operatingsystem ? {
        default => "${fai::params::aptdir}/keys",
    }

    $configspacedir = $::operatingsystem ? {
        default => '/srv/fai/config'
    }
    # Directory on the install server where the nfsroot for FAI is created,
    # approx size: 390MB
    $nfsrootdir = $::operatingsystem ? {
        default => '/srv/fai/nfsroot'
    }
    # TFTP directory for FAI files
    $tftpdir = $::operatingsystem ? {
        default => '/srv/tftp/fai'
    }

    $configdir_mode = $::operatingsystem ? {
        default => '0755',
    }
    $configdir_owner = $::operatingsystem ? {
        default => 'root',
    }
    $configdir_group = $::operatingsystem ? {
        default => $admingroup,
    }

    # Config fles
    $configfile = $::operatingsystem ? {
        default => '/etc/fai/fai.conf',
    }
    $make_nfsroot_configfile = $::lsbdistcodename ? {
        'squeeze' => '/etc/fai/make-fai-nfsroot.conf',
        'wheezy'  => '/etc/fai/nfsroot.conf',
        default   => '/etc/fai/nfsroot.conf'
    }
    $nfsroot_configfile = $::operatingsystem ? {
        default => '/etc/fai/NFSROOT',
    }
    $nfsroot_hookdir = $::operatingsystem ? {
        default => '/etc/fai/nfsroot-hooks',
    }
    $nfsroot_kernelversion = $::operatingsystem ? {
        default => $::kernelversion
    }

    $apt_sources = $::operatingsystem ? {
        default => '/etc/fai/apt/sources.list',
    }

    $configfile_mode = $::operatingsystem ? {
        default => '0600',
    }
    $configfile_owner = $::operatingsystem ? {
        default => 'root',
    }
    $configfile_group = $::operatingsystem ? {
        default => $admingroup,
    }

    $hookfile_mode = $::operatingsystem ? {
        default => '0755',
    }

}

