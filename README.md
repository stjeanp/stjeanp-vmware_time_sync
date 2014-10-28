#vmware_time_sync

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with vmware_time_sync](#setup)
    * [What vmware_time_sync affects](#what-vmware_time_sync-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with vmware_time_sync](#beginning-with-vmware_time_sync)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module implements a custom fact, vmware_tools_timesync, which it uses to determine whether or not to run the command to turn the VMware tools time synchronization on or off, based on the argument supplied. Currently it works on any OS that sets $::osfamily to RedHat, Debian, or Suse.

##Module Description

The vmware_time_sync module turns vmware tools time synchronization on or off based on the argument supplied. It implements a custom fact to determine whether or not to call vmware-toolbox-cmd.

##Setup

###What vmware_time_sync affects

* The virtual machine configuration on the ESX/ESXi host.

###Setup Requirements **REQUIRED**

* Ensure that VMware Tools is installed and that vmware-toolbox-cmd is in /usr/bin
* Ensure that pluginsync is set to true in your puppet.conf file.

###Beginning with vmware_time_sync

Ensure that VMware tools are installed and that vmware-toolbox-cmd is in /usr/bin. Turn on pluginsync if it's not already enabled.

##Usage

The default behavior is to disable time synchronization using VMware tools, which is the best practices recommendation from VMware and RedHat.

```puppet
include vmware_time_sync
```

If, for some reason, you need to enable it, do this.

```puppet
class { 'vmware_time_sync':
  enable_sync => true,
}
```

##Reference

####Class: `vmware_time_sync`

##Limitations

This module has been tested on :
* Red Hat Enterprise Linux (RHEL) 6.5
* CentOs 6.5

It should work on :
* Red Hat Enterprise Linux (RHEL) 5,6,7
* CentOs 5,6,7
* Oracle Linux 5,6,7
* Scientific Linux 5,6,7

##Development

Updates and tweaks are welcome.
