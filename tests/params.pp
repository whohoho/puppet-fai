# File::      <tt>params.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'fai::params'

$names = ['ensure', 'allowed_clients', 'loguser', 'logproto', 'configspace_provider', 'configspace_url', 'debmirror', 'debmirror_exportdir', 'debmirror_mountdir', 'debootstrap_suite', 'debootstrap_opts', 'rootpw_hash', 'ssh_identity', 'ipmiuser', 'use_backports', 'initramfs_modules', 'packagename', 'extra_packages', 'admingroup', 'logdir', 'logdir_mode', 'logdir_owner', 'logdir_group', 'piddir', 'piddir_mode', 'piddir_owner', 'piddir_group', 'configdir', 'aptdir', 'aptkeysdir', 'configspacedir', 'nfsrootdir', 'tftpdir', 'configdir_mode', 'configdir_owner', 'configdir_group', 'configfile', 'make_nfsroot_configfile', 'nfsroot_configfile', 'nfsroot_hookdir', 'nfsroot_kernelversion', 'apt_sources', 'configfile_mode', 'configfile_owner', 'configfile_group', 'hookfile_mode']

notice("fai::params::ensure = ${fai::params::ensure}")
notice("fai::params::allowed_clients = ${fai::params::allowed_clients}")
notice("fai::params::loguser = ${fai::params::loguser}")
notice("fai::params::logproto = ${fai::params::logproto}")
notice("fai::params::configspace_provider = ${fai::params::configspace_provider}")
notice("fai::params::configspace_url = ${fai::params::configspace_url}")
notice("fai::params::debmirror = ${fai::params::debmirror}")
notice("fai::params::debmirror_exportdir = ${fai::params::debmirror_exportdir}")
notice("fai::params::debmirror_mountdir = ${fai::params::debmirror_mountdir}")
notice("fai::params::debootstrap_suite = ${fai::params::debootstrap_suite}")
notice("fai::params::debootstrap_opts = ${fai::params::debootstrap_opts}")
notice("fai::params::rootpw_hash = ${fai::params::rootpw_hash}")
notice("fai::params::ssh_identity = ${fai::params::ssh_identity}")
notice("fai::params::ipmiuser = ${fai::params::ipmiuser}")
notice("fai::params::use_backports = ${fai::params::use_backports}")
notice("fai::params::initramfs_modules = ${fai::params::initramfs_modules}")
notice("fai::params::packagename = ${fai::params::packagename}")
notice("fai::params::extra_packages = ${fai::params::extra_packages}")
notice("fai::params::admingroup = ${fai::params::admingroup}")
notice("fai::params::logdir = ${fai::params::logdir}")
notice("fai::params::logdir_mode = ${fai::params::logdir_mode}")
notice("fai::params::logdir_owner = ${fai::params::logdir_owner}")
notice("fai::params::logdir_group = ${fai::params::logdir_group}")
notice("fai::params::piddir = ${fai::params::piddir}")
notice("fai::params::piddir_mode = ${fai::params::piddir_mode}")
notice("fai::params::piddir_owner = ${fai::params::piddir_owner}")
notice("fai::params::piddir_group = ${fai::params::piddir_group}")
notice("fai::params::configdir = ${fai::params::configdir}")
notice("fai::params::aptdir = ${fai::params::aptdir}")
notice("fai::params::aptkeysdir = ${fai::params::aptkeysdir}")
notice("fai::params::configspacedir = ${fai::params::configspacedir}")
notice("fai::params::nfsrootdir = ${fai::params::nfsrootdir}")
notice("fai::params::tftpdir = ${fai::params::tftpdir}")
notice("fai::params::configdir_mode = ${fai::params::configdir_mode}")
notice("fai::params::configdir_owner = ${fai::params::configdir_owner}")
notice("fai::params::configdir_group = ${fai::params::configdir_group}")
notice("fai::params::configfile = ${fai::params::configfile}")
notice("fai::params::make_nfsroot_configfile = ${fai::params::make_nfsroot_configfile}")
notice("fai::params::nfsroot_configfile = ${fai::params::nfsroot_configfile}")
notice("fai::params::nfsroot_hookdir = ${fai::params::nfsroot_hookdir}")
notice("fai::params::nfsroot_kernelversion = ${fai::params::nfsroot_kernelversion}")
notice("fai::params::apt_sources = ${fai::params::apt_sources}")
notice("fai::params::configfile_mode = ${fai::params::configfile_mode}")
notice("fai::params::configfile_owner = ${fai::params::configfile_owner}")
notice("fai::params::configfile_group = ${fai::params::configfile_group}")
notice("fai::params::hookfile_mode = ${fai::params::hookfile_mode}")

#each($names) |$v| {
#    $var = "fai::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
