# File::      <tt>init.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: fai
#
# Configure and manage the Fully Automatic Installation (FAI) system
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of fai
# $allowed_clients:: *Default*: '*'. Specification of the hosts which can mount
#           this FAI config space directory via NFS.
# $configspacedir:: *Default*: '/srv/fai/config'.
#           Directory hosting the configuration space on the install server
# $configspace_provider:: *Default*: 'svn'. How to access the fai config space
# $configspace_url:: *Default*: 'svn.gforge.uni.lu/svn/ulclusters/'.
#           URL to access the config space
# $debmirror:: Hostname of the server that provides the Debian mirror via NFS
# $debmirror_exportdir:: *Default*: '/export/debmirror'. Export directory *on*
#           the debmirror server.
# $debmirror_mountdir:: *Default*: '/mnt/debmirror'. Local mount point where
#           the mirror will be mounted
# $debootstrap_suite:: *Default*: 'wheezy'. Suite (i.e.) distribution to be
#           used to generate the FAI NFSroot directory, see make-fai-nfsroot(8)
# $debootstrap_opts:: *Default*: '--exclude=dhcp-client,info --arch amd64'.
#           Options to be passed to debootstrap -- see make-fai-nfsroot(8).
# $deploynode_basename:: *Default*: 'node-'. Basename of the hostname of the
#           deployed nodes. It means nodes can be reach in the range
#           node-<minindex> .. node-<maxindex>
# $deploynode_minindex:: *Default*: 1. Minimal index of the deployed node.
# $deploynode_minindex:: *Default*: 1. Maximal index of the deployed node
# $ipmiuser:: *Default*: 'administrator'. The IPMI user to connect by IPMI to
#           the BMC card of the deployed nodes.
# $loguser:: *Default*: '' (i.e. disabled).
#           Account on the install server which saves all log-files and which
#           can change the kernel that is booted via network.
#           Define it, to enable it.
# $logproto:: *Default*: 'ssh'. Set protocol type for saving logs.
# $nfsrootdir:: *Default*: '/srv/fai/nfsroot'. Directory on the install server
#           where the nfsroot for FAI is created, approx size: 390MB.
# $nfsroot_hookdir:: *Default*: '/srv/fai/nfsroot-hooks'. Directory containing
#           shell scripts to be sourced at the end of make-fai-nfsroot for
#           additional configuration of the nfsroot.
# $rootpw_hash:: *Default*: '$1$kBnWcO.E$djxB128U7dMkrltJHPf6d1'.
#           The encrypted (with md5 or crypt) root password on all install
#           clients during installation process; used when log in via ssh;
#           Default password is: fai. You can create the encrypted password
#           using mkpasswd(1) and use the crypt(3) or md5 algorithm.
# $tftpdir:: *Default*: '/srv/tftp/fai/'. TFTP directory for FAI files
#
# == Actions:
#
# Install and configure fai
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     include 'fai'
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'fai':
#             ensure => 'present'
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class fai(
    $ensure                = $fai::params::ensure,
    $deploynode_basename   = 'node-',
    $deploynode_minindex   = 1,
    $deploynode_maxindex   = 1,
    $configspacedir        = $fai::params::configspacedir,
    $nfsrootdir            = $fai::params::nfsrootdir,
    $nfsroot_hookdir       = $fai::params::nfsroot_hookdir,
    $nfsroot_kernelversion = $fai::params::nfsroot_kernelversion,
    $tftpdir               = $fai::params::tftpdir,
    $loguser               = $fai::params::loguser,
    $logproto              = $fai::params::logproto,
    $configspace_provider  = $fai::params::configspace_provider,
    $configspace_url       = $fai::params::configspace_url,
    $debmirror             = $fai::params::debmirror,
    $debmirror_exportdir   = $fai::params::debmirror_exportdir,
    $debmirror_mountdir    = $fai::params::debmirror_mountdir,
    $debootstrap_suite     = $fai::params::debootstrap_suite,
    $debootstrap_opts      = $fai::params::debootstrap_opts,
    $rootpw_hash           = $fai::params::rootpw_hash,
    $ssh_identity          = $fai::params::ssh_identity,
    $allowed_clients       = $fai::params::allowed_clients,
    $ipmiuser              = $fai::params::ipmiuser,
    $use_backports         = $fai::params::use_backports,
    $initramfs_modules     = $fai::params::initramfs_modules
)
inherits fai::params
{
    info ("Configuring fai (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("fai 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ! ($configspace_provider in [ 'svn', 'git' ]) {
        fail("Unsupported provider '${configspace_provider} for the FAI configuration space")
    }

    case $::operatingsystem {
        'debian', 'ubuntu':         { include ::fai::common::debian }
        default: {
            fail("Module ${::module_name} is not supported on ${::operatingsystem}")
        }
    }
}

