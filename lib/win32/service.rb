require 'win32ole'
require 'socket'

module Win32
  class Service

    # Our base connection string
    @@bcs = "winmgmts:{impersonationLevel=impersonate}"

    ServiceStruct = Struct.new(
      'Service',
      :AcceptPause,
      :AcceptStop,
      :Caption,
      :CheckPoint,
      :CreationClassName,
      :Description,
      :DesktopInteract,
      :DisplayName,
      :ErrorControl,
      :ExitCode,
      :InstallDate,
      :Name,
      :PathName,
      :ProcessId,
      :ServiceSpecificExitCode,
      :ServiceType,
      :Started,
      :StartName,
      :State,
      :Status,
      :SystemCreationClassName,
      :SystemName,
      :TagId,
      :WaitHint
    )

    class Error < StandardError; end

    def self.services(host=Socket.gethostname)
      connect_string = @@bcs + "//#{host}/root/cimv2"     

      begin
        wmi = WIN32OLE.connect(connect_string)
      rescue WIN32OLERuntimeError => err
        raise Error, err
      else
        wmi.InstancesOf('Win32_Service').each{ |service|
          struct = ServiceStruct.new
          struct.members.each do |m|
            struct.send("#{m}=", service.send(m))
          end
          yield struct
        }
      end
    end
  end
end
