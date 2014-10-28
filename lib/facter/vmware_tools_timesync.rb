require 'facter'
Facter.add("vmware_tools_timesync") do
  setcode do
    if File.exists?("/usr/bin/vmware-toolbox-cmd")
      out = Facter::Util::Resolution.exec('/usr/bin/vmware-toolbox-cmd timesync status 2>&1')
    end
    
    if out == nil
      timesync = "unknown"
    else
      case out.downcase
        when "enabled"
          timesync = "enabled"
        when "disabled"
          timesync = "disabled"
        else
          timesync = "unknown"
      end
    end
  end
end
      