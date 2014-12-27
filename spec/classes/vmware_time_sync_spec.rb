require 'spec_helper'

describe 'vmware_time_sync', :type => :class do
  after :each do
    Facter.clear
    Facter.clear_messages
  end

  context 'Enable on something not a VMware VM' do
    let :params do
      {
        :enable_sync => true,
      }
    end
    let :facts do
      {
        :virtual => '',
        :vmware_tools_timesync => 'disabled',
      }
    end

    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /This node is not a VMware virtual machine./)
    end
  end

  context 'Disable on something not a VMware VM' do
    let :params do
      {
        :enable_sync => false,
      }
    end
    let :facts do
      {
        :virtual => '',
        :vmware_tools_timesync => 'enabled',
      }
    end

    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /This node is not a VMware virtual machine./)
    end
  end

  context 'Handle missing custom fact' do
    let :params do
      {
        :enable_sync => false,
      }
    end
    let :facts do
      {
        :virtual => 'vmware',
      }
    end

    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /Custom fact vmware_tools_timesync missing./)
    end
  end

  context 'Handle bad custom fact' do
    let :params do
      {
        :enable_sync => false,
      }
    end
    let :facts do
      {
        :virtual => 'vmware',
        :vmware_tools_timesync => 'unknown',
      }
    end

    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /Unable to determine VMware Tools timesync status./)
    end
  end

  context 'Disable on a VMware VM that is already disabled' do
    let :params do
      {
        :enable_sync => false,
      }
    end
    let :facts do
      {
        :virtual => 'vmware',
        :vmware_tools_timesync => 'disabled',
      }
    end

    it { should compile }
    it { should_not contain_exec('timesync') }
  end

  context 'Disable on a VMware VM that is enabled' do
    let :params do
      {
        :enable_sync => false,
      }
    end
    let :facts do
      {
        :virtual => 'vmware',
        :vmware_tools_timesync => 'enabled',
      }
    end

    it { should compile }
    it { should contain_exec('timesync').with(
      'command' => '/usr/bin/vmware-toolbox-cmd timesync disable',
    ) }
  end

  context 'Enable on a VMware VM that is enabled' do
    let :params do
      {
        :enable_sync => true,
      }
    end
    let :facts do
      {
        :virtual => 'vmware',
        :vmware_tools_timesync => 'enabled',
      }
    end

    it { should compile }
    it { should_not contain_exec('timesync') }
  end

  context 'Enable on a VMware VM that is disabled' do
    let :params do
      {
        :enable_sync => true,
      }
    end
    let :facts do
      {
        :virtual => 'vmware',
        :vmware_tools_timesync => 'disabled',
      }
    end

    it { should compile }
    it { should contain_exec('timesync').with(
      'command' => '/usr/bin/vmware-toolbox-cmd timesync enable',
    ) }
  end
end
