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
        k = k.to_s.downcase
        options[k] = v
      }

      name = option.fetch('name'){
        raise ArgumentError, "service name missing"
      }

      host = options.delete('host') || Socket.gethostname

      log_deps  = options['loadordergroupdependencies']
      serv_deps = options['servicedependencies']

      if log_deps && log_deps.is_a?(Array)
        log_deps = log_deps.join("\0")
        log_deps << "\000\000"
      end

      if serv_deps && service_deps.is_a?(Array)
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
        name,
        options['displayname'],
        options['pathname'],
        options['servicetype'],
        options['errorcontrol'],
        options['startmode'],
        options['desktopinteract'],
        options['startname'],
        options['startpassword'],
        options['loadordergroup'],
        log_deps,
        serv_deps
      )

      if rv != 0
        raise Error, "Failed to create service. Error code: #{rv}."
      end

      @wmi = wmi
    end

    def self.configure(options)
      options.each{ |k,v|
        k = k.to_s.downcase
        options[k] = v
      }

      name = options.fetch('name'){
        raise ArgumentError, "service name missing"
      }

      host = options.delete('host') || Socket.gethostname

      log_deps  = options['loadordergroupdependencies']
      serv_deps = options['servicedependencies']

      if log_deps && log_deps.is_a?(Array)
        log_deps = log_deps.join("\0")
        log_deps << "\000\000"
      end

      if serv_deps && service_deps.is_a?(Array)
        serv_deps = serv_deps.join("\0")
        serv_deps << "\000\000"
      end

      wmi = connect_to_service(name, host)

      rv = wmi.Change(
        options['displayname'],
        options['pathname'],
        options['servicetype'],
        options['errorcontrol'],
        options['startmode'],
        options['desktopinteract'],
        options['startname'],
        options['startpassword'],
        options['loadordergroup'],
        log_deps,
        serv_deps
      )

      if rv != 0
        raise Error, "Failed to create service. Error code: #{rv}."
      end
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

    def self.delete(service, host=Socket.gethostname)
      wmi = connect_to_service(service, host)
      rc  = wmi.Delete

      if rc != 0
        raise Error, "Failed to delete service. Error code #{rc}."
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
