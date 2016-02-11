-*- mode: markdown; mode: visual-line;  -*-

# Fai Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/fai.svg)](https://forge.puppetlabs.com/ULHPC/fai)
[![License](http://img.shields.io/:license-GPL3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian-lightgrey.svg)
[![Documentation Status](https://readthedocs.org/projects/ulhpc-puppet-fai/badge/?version=latest)](https://readthedocs.org/projects/ulhpc-puppet-fai/?badge=latest)

Configure and manage the Fully Automatic Installation (FAI) system

      Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team <hpc-sysadmins@uni.lu>
      

| [Project Page](https://github.com/ULHPC/puppet-fai) | [Sources](https://github.com/ULHPC/puppet-fai) | [Documentation](https://ulhpc-puppet-fai.readthedocs.org/en/latest/) | [Issues](https://github.com/ULHPC/puppet-fai/issues) |

## Synopsis

Configure and manage the Fully Automatic Installation (FAI) system.

This module implements the following elements: 

* __Puppet classes__:
    - `fai` 
    - `fai::common` 
    - `fai::common::debian` 
    - `fai::params` 

* __Puppet definitions__: 

All these components are configured through a set of variables you will find in
[`manifests/params.pp`](manifests/params.pp). 

_Note_: the various operations that can be conducted from this repository are piloted from a [`Rakefile`](https://github.com/ruby/rake) and assumes you have a running [Ruby](https://www.ruby-lang.org/en/) installation.
See `docs/contributing.md` for more details on the steps you shall follow to have this `Rakefile` working properly. 

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on 

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [puppetlabs/tftp](https://forge.puppetlabs.com/puppetlabs/tftp)
* [puppetlabs/vcsrepo](https://forge.puppetlabs.com/puppetlabs/vcsrepo)
* [puppetlabs/apt](https://forge.puppetlabs.com/puppetlabs/apt)
* [ULHPC/nfs](https://forge.puppetlabs.com/ULHPC/nfs)

## Overview and Usage

### Class `fai`

This is the main class defined in this module.
It accepts the following parameters: 

* `$ensure`: default to 'present', can be 'absent'

Use it as follows:

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

See also [`tests/init.pp`](tests/init.pp)



## Librarian-Puppet / R10K Setup

You can of course configure the fai module in your `Puppetfile` to make it available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC/fai"

or, if you prefer to work on the git version: 

     mod "ULHPC/fai", 
         :git => 'https://github.com/ULHPC/puppet-fai',
         :ref => 'production' 

## Issues / Feature request

You can submit bug / issues / feature request using the [ULHPC/fai Puppet Module Tracker](https://github.com/ULHPC/puppet-fai/issues). 

## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module is organized. 
These elements are detailed on [`docs/contributing.md`](contributing/index.md).

You are more than welcome to contribute to its development by [sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Puppet modules tests within a Vagrant box

The best way to test this module in a non-intrusive way is to rely on [Vagrant](http://www.vagrantup.com/).
The `Vagrantfile` at the root of the repository pilot the provisioning various vagrant boxes available on [Vagrant cloud](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=virtualbox&q=svarrette) you can use to test this module.

See [`docs/vagrant.md`](vagrant.md) for more details. 

## Online Documentation

[Read the Docs](https://readthedocs.org/) aka RTFD hosts documentation for the open source community and the [ULHPC/fai](https://github.com/ULHPC/puppet-fai) puppet module has its documentation (see the `docs/` directly) hosted on [readthedocs](http://ulhpc-puppet-fai.rtfd.org).

See [`docs/rtfd.md`](rtfd.md) for more details.

## Licence

This project and the sources proposed within this repository are released under the terms of the [GPL-3.0](LICENCE) licence.


[![Licence](https://www.gnu.org/graphics/gplv3-88x31.png)](LICENSE)
