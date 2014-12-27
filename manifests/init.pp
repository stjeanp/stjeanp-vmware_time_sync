# Class: vmware_time_sync
#
# This module manages vmware_time_sync
#
# Parameters: none
#
# Actions:
#
# Requires: see README.md
#
# Sample Usage:
#
class vmware_time_sync (
  $enable_sync = false,
) {
  if $::virtual != 'vmware' {
    fail('This node is not a VMware virtual machine.')
  }

  if $::vmware_tools_timesync == undef {
    fail('Custom fact vmware_tools_timesync missing.')
  }
  
  if !member(['enabled', 'disabled'], $::vmware_tools_timesync) {
    fail('Unable to determine VMware Tools timesync status.')
  }

  if $enable_sync == true {
    $expected_state = 'enabled'
    $toolbox_args = 'timesync enable'
  }else{
    $expected_state = 'disabled'
    $toolbox_args = 'timesync disable'
  }
  
  if $expected_state != $::vmware_tools_timesync {
    $toolbox_command = '/usr/bin/vmware-toolbox-cmd'
    
    exec { 'timesync':
      command => "${toolbox_command} ${toolbox_args}",
      path    => '/bin:/usr/bin',
      onlyif  => "test -e ${toolbox_command}",
      returns => 0,
      user    => 'root',
    }
  }
}
