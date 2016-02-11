# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
#
#
# You can execute this manifest as follows in your vagrant box:
#
#      sudo puppet apply -t /vagrant/tests/init.pp
#
node default {
    class { 'fai':
        deploynode_basename   => 'node-',
        deploynode_minindex   => 1,
        deploynode_maxindex   => 200,
        configspace_provider  => 'git',
        configspace_url       => 'https://github.com/faiproject/fai',
        debmirror             => '10.20.30.40',
        debmirror_exportdir   => '/export/debmirror',
        debmirror_mountdir    => '/mnt/debmirror',
        debootstrap_suite     => 'wheezy',
        ssh_identity          => '/root/.ssh/id_dsa.pub',
        allowed_clients       => '10.20.0.0/16',
        ipmiuser              => 'ipmiadmin',
        use_backports         => false,
        nfsroot_kernelversion => '3.2.0-4-amd64',
        initramfs_modules     => [ 'bnx2', 'tg3', 'mpt3sas', 'mlx4_core', 'mlx4_en' ]
    }
}
