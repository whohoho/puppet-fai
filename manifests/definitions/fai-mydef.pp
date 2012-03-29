# File::      <tt>fai-mydef.pp</tt>
# Author::    Sebastien Varrette (Sebastien.Varrette@uni.lu)
# Copyright:: Copyright (c) 2012 Sebastien Varrette
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Defines: fai::mydef
#
# Configure and manage the Fully Automatic Installation (FAI) system
#
# == Pre-requisites
#
# * The class 'fai' should have been instanciated
#
# == Parameters:
#
# [*ensure*]
#   default to 'present', can be 'absent'.
#   Default: 'present'
#
# [*content*]
#  Specify the contents of the mydef entry as a string. Newlines, tabs,
#  and spaces can be specified using the escaped syntax (e.g., \n for a newline)
#
# [*source*]
#  Copy a file as the content of the mydef entry.
#  Uses checksum to determine when a file should be copied.
#  Valid values are either fully qualified paths to files, or URIs. Currently
#  supported URI types are puppet and file.
#  In neither the 'source' or 'content' parameter is specified, then the
#  following parameters can be used to set the console entry.
#
# == Sample usage:
#
#     include "fai"
#
# You can then add a mydef specification as follows:
#
#      fai::mydef {
#
#      }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define fai::mydef(
    $ensure         = 'present',
    $content        = '',
    $source         = ''
)
{
    include fai::params

    # $name is provided at define invocation
    $basename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("fai::mydef 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($fai::ensure != $ensure) {
        if ($fai::ensure != 'present') {
            fail("Cannot configure a fai '${basename}' as fai::ensure is NOT set to present (but ${fai::ensure})")
        }
    }

    # if content is passed, use that, else if source is passed use that
    $real_content = $content ? {
        '' => $source ? {
            ''      => template('fai/fai_entry.erb'),
            default => ''
        },
        default => $content
    }
    $real_source = $source ? {
        '' => '',
        default => $content ? {
            ''      => $source,
            default => ''
        }
    }

    # concat::fragment { "${fai::params::configfile}_${basename}":
    #     target  => "${fai::params::configfile}",
    #     ensure  => "${ensure}",
    #     content => $real_content,
    #     source  => $real_source,
    #     order   => '50',
    # }

    # case $ensure {
    #     present: {

    #     }
    #     absent: {

    #     }
    #     disabled: {

    #     }
    #     default: { err ( "Unknown ensure value: '${ensure}'" ) }
    # }

}



