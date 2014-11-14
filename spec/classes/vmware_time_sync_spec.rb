require 'rspec-puppet'
require 'spec_helper'

describe 'vmware_time_sync', :type => :class do
  context 'Enable on something not a VMware VM' do
    let(:params) { {:enable_sync => true} }
    let(:facts) { {:virtual => '', :vmware_tools_timesync => 'disabled'} }

    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /This node is not a VMware virtual machine./)
    end
  end

  context 'Disable on something not a VMware VM' do
    let(:params) { {:enable_sync => false} }
    let(:facts) { {:virtual => '', :vmware_tools_timesync => 'disabled'} }

    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /This node is not a VMware virtual machine./)
    end
  end

  context 'Handle missing custom fact' do
    let(:params) { {:enable_sync => false} }
    let(:facts) { {:virtual => 'vmware'} }

    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /Custom fact vmware_tools_timesync missing./)
    end
  end

  context 'Handle bad custom fact' do
    let(:params) { {:enable_sync => false} }
    let(:facts) { {:virtual => 'vmware', :vmware_tools_timesync => 'unknown'} }

    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /Unable to determine VMware Tools timesync status./)
    end
  end

  context 'Disable on a VMware VM that is already disabled' do
    let(:params) { {:enable_sync => false} }
    let(:facts) { {:virtual => 'vmware', :vmware_tools_timesync => 'disabled'} }

    it { should compile }
    it { should_not contain_exec('timesync') }
  end

  context 'Disable on a VMware VM that is enabled' do
    let(:params) { {:enable_sync => false} }
    let(:facts) { {:virtual => 'vmware', :vmware_tools_timesync => 'enabled'} }

    it { should compile }
    it { should contain_exec('timesync').with(
      'command' => '/usr/bin/vmware-toolbox-cmd timesync disable',
    ) }
  end

  context 'Enable on a VMware VM that is enabled' do
    let(:params) { {:enable_sync => true} }
    let(:facts) { {:virtual => 'vmware', :vmware_tools_timesync => 'enabled'} }

    it { should compile }
    it { should_not contain_exec('timesync') }
  end

  context 'Enable on a VMware VM that is disabled' do
    let(:params) { {:enable_sync => true} }
    let(:facts) { {:virtual => 'vmware', :vmware_tools_timesync => 'disabled'} }

    it { should compile }
    it { should contain_exec('timesync').with(
      'command' => '/usr/bin/vmware-toolbox-cmd timesync enable',
    ) }
  end
end
