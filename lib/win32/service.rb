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

    def initialize(options)
      options.each{ |k,v|
        k = k.to_s.downcase.capitalize
        options[k] = v
      }

      host = options.delete('Host') || Socket.gethostname

      log_deps  = options['LoadOrderGroupDependencies']
      serv_deps = options['ServiceDependencies']

      if log_deps
        log_deps = log_deps.join("\0")
        log_deps << "\000\000"
      end

      if serv_deps
        serv_deps = serv_deps.join("\0")
        serv_deps << "\000\000"
      end

      connect_string = @@bcs + "//#{host}/root/cimv2:Win32_Service"

      begin
        wmi = WIN32OLE.connect(connect_string)
      rescue WIN32OLERuntimeError => err
        raise Error, err
      end

      rv = wmi.Create(
        options['Name'],
        options['DisplayName'],
        options['Pathname'],
        options['ServiceType'],
        options['ErrorControl'],
        options['StartMode'],
        options['DesktopInteract'],
        options['StartName'],
        options['StartPassword'],
        options['LoadOrderGroup'],
        log_deps,
        serv_deps
      )

      if rv != 0
        raise Error, "Failed to create service. Error code: #{rv}."
      end

      @wmi = wmi
    end

    def self.services(host=Socket.gethostname)
      wmi = connect_to_service(nil, host)
      wmi.InstancesOf('Win32_Service').each{ |service|
        struct = ServiceStruct.new
        struct.members.each do |m|
          struct.send("#{m}=", service.send(m))
        end
        yield struct
      }
    end

    def self.exists?(service, host=Socket.gethostname)
      bool = true

      begin
        connect_to_service(service, host)
      rescue WIN32OLERuntimeError => err
        bool = false
      end

      bool
    end

    def self.display_name(service, host=Socket.gethostname)
      wmi = connect_to_service(service, host)
      wmi.Caption
    end

    def self.service_name(display_name, host=Socket.gethostname)
      wmi = connect_to_service(nil, host)
      query = "select * from win32_service where caption = '#{display_name}'"

      wmi.execquery(query).each{ |service|
        return service.name
      }
    end

    # Service control methods

    # Start the service +name+ on +host+.
    #--
    # It doesn't appear that you can pass arguments to a service with WMI.
    #
    def self.start(service, host=Socket.gethostname)
      wmi = connect_to_service(service, host)
      rc  = wmi.StartService

      if rc != 0
        raise Error, "Failed to start service. Error code #{rc}."
      end 
    end

    def self.stop(service, host=Socket.gethostname)
      wmi = connect_to_service(service, host)
      rc  = wmi.StopService

      if rc != 0
        raise Error, "Failed to stop service. Error code #{rc}."
      end 
    end

    def self.pause(service, host=Socket.gethostname)
      wmi = connect_to_service(service, host)
      rc  = wmi.PauseService

      if rc != 0
        raise Error, "Failed to pause service. Error code #{rc}."
      end 
    end

    def self.resume(service, host=Socket.gethostname)
      wmi = connect_to_service(service, host)
      rc  = wmi.ResumeService

      if rc != 0
        raise Error, "Failed to resume service. Error code #{rc}."
      end 
    end

    private

    # Wrapper for handling service conneciton to a specific service.
    def self.connect_to_service(name = nil, host = nil)
      host ||= Socket.gethostname

      if name
        connect_string = @@bcs + "//#{host}/root/cimv2:Win32_Service='#{name}'"
      else
        connect_string = @@bcs + "//#{host}/root/cimv2"
      end

      begin
        wmi = WIN32OLE.connect(connect_string)
      rescue WIN32OLERuntimeError => err
        raise Error, err
      end

      wmi
    end
  end
end
