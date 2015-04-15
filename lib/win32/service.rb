require_relative 'windows/helper'
require_relative 'windows/constants'
require_relative 'windows/structs'
require_relative 'windows/functions'

# The Win32 module serves as a namespace only.
module Win32

  # The Service class encapsulates services controller actions, such as
  # creating, starting, configuring or deleting services.
  class Service
    include Windows::ServiceConstants
    include Windows::Structs
    include Windows::Functions

    extend Windows::Structs
    extend Windows::Functions

    # The version of the win32-service library
    VERSION = '0.8.6'

    # SCM security and access rights

    # Includes STANDARD_RIGHTS_REQUIRED, in addition to all other rights
    MANAGER_ALL_ACCESS = SC_MANAGER_ALL_ACCESS

    # Required to call the CreateService function
    MANAGER_CREATE_SERVICE = SC_MANAGER_CREATE_SERVICE

    # Required to connect to the service control manager.
    MANAGER_CONNECT = SC_MANAGER_CONNECT

    # Required to call the EnumServicesStatusEx function to list services
    MANAGER_ENUMERATE_SERVICE = SC_MANAGER_ENUMERATE_SERVICE

    # Required to call the LockServiceDatabase function
    MANAGER_LOCK = SC_MANAGER_LOCK

    # Required to call the NotifyBootConfigStatus function
    MANAGER_MODIFY_BOOT_CONFIG = SC_MANAGER_MODIFY_BOOT_CONFIG

    # Required to call the QueryServiceLockStatus function
    MANAGER_QUERY_LOCK_STATUS = SC_MANAGER_QUERY_LOCK_STATUS

    # Includes STANDARD_RIGHTS_REQUIRED in addition to all access rights
    ALL_ACCESS = SERVICE_ALL_ACCESS

    # Required to call functions that configure existing services
    CHANGE_CONFIG = SERVICE_CHANGE_CONFIG

    # Required to enumerate all the services dependent on the service
    ENUMERATE_DEPENDENTS = SERVICE_ENUMERATE_DEPENDENTS

    # Required to make a service report its status immediately
    INTERROGATE = SERVICE_INTERROGATE

    # Required to control a service with a pause or resume
    PAUSE_CONTINUE = SERVICE_PAUSE_CONTINUE

    # Required to be able to gather configuration information about a service
    QUERY_CONFIG = SERVICE_QUERY_CONFIG

    # Required to be ask the SCM about the status of a service
    QUERY_STATUS = SERVICE_QUERY_STATUS

    # Required to call the StartService function to start the service.
    START = SERVICE_START

    # Required to call the ControlService function to stop the service.
    STOP = SERVICE_STOP

    # Required to call ControlService with a user defined control code
    USER_DEFINED_CONTROL = SERVICE_USER_DEFINED_CONTROL

    # Service Types

    # Driver service
    KERNEL_DRIVER = SERVICE_KERNEL_DRIVER

    # File system driver service
    FILE_SYSTEM_DRIVER  = SERVICE_FILE_SYSTEM_DRIVER

    # Service that runs in its own process
    WIN32_OWN_PROCESS = SERVICE_WIN32_OWN_PROCESS

    # Service that shares a process with one or more other services.
    WIN32_SHARE_PROCESS = SERVICE_WIN32_SHARE_PROCESS

    # The service can interact with the desktop
    INTERACTIVE_PROCESS = SERVICE_INTERACTIVE_PROCESS

    DRIVER = SERVICE_DRIVER
    TYPE_ALL = SERVICE_TYPE_ALL

    # Service start options

    # A service started automatically by the SCM during system startup
    BOOT_START = SERVICE_BOOT_START

    # A device driver started by the IoInitSystem function. Drivers only
    SYSTEM_START = SERVICE_SYSTEM_START

    # A service started automatically by the SCM during system startup
    AUTO_START = SERVICE_AUTO_START

    # A service started by the SCM when a process calls StartService
    DEMAND_START = SERVICE_DEMAND_START

    # A service that cannot be started
    DISABLED = SERVICE_DISABLED

    # Error control

    # Error logged, startup continues
    ERROR_IGNORE = SERVICE_ERROR_IGNORE

    # Error logged, pop up message, startup continues
    ERROR_NORMAL   = SERVICE_ERROR_NORMAL

    # Error logged, startup continues, system restarted last known good config
    ERROR_SEVERE   = SERVICE_ERROR_SEVERE

    # Error logged, startup fails, system restarted last known good config
    ERROR_CRITICAL = SERVICE_ERROR_CRITICAL

    # Current state

    # Service is not running
    STOPPED = SERVICE_STOPPED

    # Service has received a start signal but is not yet running
    START_PENDING = SERVICE_START_PENDING

    # Service has received a stop signal but is not yet stopped
    STOP_PENDING  = SERVICE_STOP_PENDING

    # Service is running
    RUNNING = SERVICE_RUNNING

    # Service has received a signal to resume but is not yet running
    CONTINUE_PENDING = SERVICE_CONTINUE_PENDING

    # Service has received a signal to pause but is not yet paused
    PAUSE_PENDING = SERVICE_PAUSE_PENDING

    # Service is paused
    PAUSED = SERVICE_PAUSED

    # Service controls

    # Notifies service that it should stop
    CONTROL_STOP = SERVICE_CONTROL_STOP

    # Notifies service that it should pause
    CONTROL_PAUSE = SERVICE_CONTROL_PAUSE

    # Notifies service that it should resume
    CONTROL_CONTINUE = SERVICE_CONTROL_CONTINUE

    # Notifies service that it should return its current status information
    CONTROL_INTERROGATE = SERVICE_CONTROL_INTERROGATE

    # Notifies a service that its parameters have changed
    CONTROL_PARAMCHANGE = SERVICE_CONTROL_PARAMCHANGE

    # Notifies a service that there is a new component for binding
    CONTROL_NETBINDADD = SERVICE_CONTROL_NETBINDADD

    # Notifies a service that a component for binding has been removed
    CONTROL_NETBINDREMOVE = SERVICE_CONTROL_NETBINDREMOVE

    # Notifies a service that a component for binding has been enabled
    CONTROL_NETBINDENABLE = SERVICE_CONTROL_NETBINDENABLE

    # Notifies a service that a component for binding has been disabled
    CONTROL_NETBINDDISABLE = SERVICE_CONTROL_NETBINDDISABLE

    # Failure actions

    # No action
    ACTION_NONE = SC_ACTION_NONE

    # Reboot the computer
    ACTION_REBOOT = SC_ACTION_REBOOT

    # Restart the service
    ACTION_RESTART = SC_ACTION_RESTART

    # Run a command
    ACTION_RUN_COMMAND = SC_ACTION_RUN_COMMAND

    # :stopdoc: #

    StatusStruct = Struct.new(
      'ServiceStatus',
      :service_type,
      :current_state,
      :controls_accepted,
      :win32_exit_code,
      :service_specific_exit_code,
      :check_point,
      :wait_hint,
      :interactive,
      :pid,
      :service_flags
    )

    ConfigStruct = Struct.new(
      'ServiceConfigInfo',
      :service_type,
      :start_type,
      :error_control,
      :binary_path_name,
      :load_order_group,
      :tag_id,
      :dependencies,
      :service_start_name,
      :display_name
    )

    ServiceStruct = Struct.new(
      'ServiceInfo',
      :service_name,
      :display_name,
      :service_type,
      :current_state,
      :controls_accepted,
      :win32_exit_code,
      :service_specific_exit_code,
      :check_point,
      :wait_hint,
      :binary_path_name,
      :start_type,
      :error_control,
      :load_order_group,
      :tag_id,
      :start_name,
      :dependencies,
      :description,
      :interactive,
      :pid,
      :service_flags,
      :reset_period,
      :reboot_message,
      :command,
      :num_actions,
      :actions,
      :delayed_start
    )

    # :startdoc: #

    # Creates a new service with the specified +options+. A +service_name+
    # must be specified or an ArgumentError is raised. A +host+ option may
    # be specified. If no host is specified the local machine is used.
    #
    # Possible Options:
    #
    # * service_name           => nil (you must specify)
    # * host                   => nil (optional)
    # * display_name           => service_name
    # * desired_access         => Service::ALL_ACCESS
    # * service_type           => Service::WIN32_OWN_PROCESS
    # * start_type             => Service::DEMAND_START
    # * error_control          => Service::ERROR_NORMAL
    # * binary_path_name       => nil
    # * load_order_group       => nil
    # * dependencies           => nil
    # * service_start_name     => nil
    # * password               => nil
    # * description            => nil
    # * failure_reset_period   => nil,
    # * failure_reboot_message => nil,
    # * failure_command        => nil,
    # * failure_actions        => nil,
    # * failure_delay          => 0
    #
    # Example:
    #
    #    # Configure everything
    #    Service.new(
    #      :service_name       => 'some_service',
    #      :host               => 'localhost',
    #      :service_type       => Service::WIN32_OWN_PROCESS,
    #      :description        => 'A custom service I wrote just for fun',
    #      :start_type         => Service::AUTO_START,
    #      :error_control      => Service::ERROR_NORMAL,
    #      :binary_path_name   => 'C:\path\to\some_service.exe',
    #      :load_order_group   => 'Network',
    #      :dependencies       => ['W32Time','Schedule'],
    #      :service_start_name => 'SomeDomain\\User',
    #      :password           => 'XXXXXXX',
    #      :display_name       => 'This is some service',
    #    )
    #
    def initialize(options={})
      unless options.is_a?(Hash)
        raise ArgumentError, 'options parameter must be a hash'
      end

      if options.empty?
        raise ArgumentError, 'no options provided'
      end

      opts = {
        'display_name'           => nil,
        'desired_access'         => SERVICE_ALL_ACCESS,
        'service_type'           => SERVICE_WIN32_OWN_PROCESS,
        'start_type'             => SERVICE_DEMAND_START,
        'error_control'          => SERVICE_ERROR_NORMAL,
        'binary_path_name'       => nil,
        'load_order_group'       => nil,
        'dependencies'           => nil,
        'service_start_name'     => nil,
        'password'               => nil,
        'description'            => nil,
        'failure_reset_period'   => nil,
        'failure_reboot_message' => nil,
        'failure_command'        => nil,
        'failure_actions'        => nil,
        'failure_delay'          => 0,
        'host'                   => nil,
        'service_name'           => nil
      }

      # Validate the hash options
      options.each{ |key, value|
        key = key.to_s.downcase
        unless opts.include?(key)
          raise ArgumentError, "Invalid option '#{key}'"
        end
        opts[key] = value
      }

      unless opts['service_name']
        raise ArgumentError, 'No service_name specified'
      end

      service_name = opts.delete('service_name')
      host = opts.delete('host')

      raise TypeError unless service_name.is_a?(String)
      raise TypeError if host && !host.is_a?(String)

      begin
        handle_scm = OpenSCManager(host, nil, SC_MANAGER_CREATE_SERVICE)

        FFI.raise_windows_error('OpenSCManager') if handle_scm == 0

        # Display name defaults to service_name
        opts['display_name'] ||= service_name

        dependencies = opts['dependencies']

        if dependencies && !dependencies.empty?
          unless dependencies.is_a?(Array) || dependencies.is_a?(String)
            raise TypeError, 'dependencies must be a string or array'
          end

          if dependencies.is_a?(Array)
            dependencies = dependencies.join("\000")
          end

          dependencies += "\000"
          dependencies = FFI::MemoryPointer.from_string(dependencies)
        end

        handle_scs = CreateService(
          handle_scm,
          service_name,
          opts['display_name'],
          opts['desired_access'],
          opts['service_type'],
          opts['start_type'],
          opts['error_control'],
          opts['binary_path_name'],
          opts['load_order_group'],
          nil,
          dependencies,
          opts['service_start_name'],
          opts['password']
        )

        FFI.raise_windows_error('CreateService') if handle_scs == 0

        if opts['description']
          description = SERVICE_DESCRIPTION.new
          description[:lpDescription] = FFI::MemoryPointer.from_string(opts['description'])

          bool = ChangeServiceConfig2(
            handle_scs,
            SERVICE_CONFIG_DESCRIPTION,
            description
          )

          FFI.raise_windows_error('ChangeServiceConfig2') unless bool
        end

        if opts['failure_reset_period'] || opts['failure_reboot_message'] ||
           opts['failure_command'] || opts['failure_actions']
        then
          Service.configure_failure_actions(handle_scs, opts)
        end
      ensure
        CloseServiceHandle(handle_scs) if handle_scs && handle_scs > 0
        CloseServiceHandle(handle_scm) if handle_scm && handle_scm > 0
      end

      self
    end

    # Configures the named +service+ on +host+, or the local host if no host
    # is specified. The +options+ parameter is a hash that can contain any
    # of the following parameters:
    #
    # * service_type
    # * start_type
    # * error_control
    # * binary_path_name
    # * load_order_group
    # * dependencies
    # * service_start_name
    # * password (used with service_start_name)
    # * display_name
    # * description
    # * failure_reset_period
    # * failure_reboot_message
    # * failure_command
    # * failure_actions
    # * failure_delay
    #
    # Examples:
    #
    #    # Configure only the display name
    #    Service.configure(
    #      :service_name => 'some_service',
    #      :display_name => 'Test 33'
    #    )
    #
    #    # Configure everything
    #    Service.configure(
    #       :service_name       => 'some_service'
    #       :service_type       => Service::WIN32_OWN_PROCESS,
    #       :start_type         => Service::AUTO_START,
    #       :error_control      => Service::ERROR_NORMAL,
    #       :binary_path_name   => 'C:\path\to\some_service.exe',
    #       :load_order_group   => 'Network',
    #       :dependencies       => ['W32Time','Schedule']
    #       :service_start_name => 'SomeDomain\\User',
    #       :password           => 'XXXXXXX',
    #       :display_name       => 'This is some service',
    #       :description        => 'A custom service I wrote just for fun'
    #    )
    #
    def self.configure(options={})
      unless options.is_a?(Hash)
        raise ArgumentError, 'options parameter must be a hash'
      end

      if options.empty?
        raise ArgumentError, 'no options provided'
      end

      opts = {
        'service_type'           => SERVICE_NO_CHANGE,
        'start_type'             => SERVICE_NO_CHANGE,
        'error_control'          => SERVICE_NO_CHANGE,
        'binary_path_name'       => nil,
        'load_order_group'       => nil,
        'dependencies'           => nil,
        'service_start_name'     => nil,
        'password'               => nil,
        'display_name'           => nil,
        'description'            => nil,
        'failure_reset_period'   => nil,
        'failure_reboot_message' => nil,
        'failure_command'        => nil,
        'failure_actions'        => nil,
        'failure_delay'          => 0,
        'service_name'           => nil,
        'host'                   => nil,
        'delayed_start'          => false
      }

      # Validate the hash options
      options.each{ |key, value|
        key = key.to_s.downcase
        unless opts.include?(key)
          raise ArgumentError, "Invalid option '#{key}'"
        end
        opts[key] = value
      }

      unless opts['service_name']
        raise ArgumentError, 'No service_name specified'
      end

      if windows_version < 6 && options.include?(:delayed_start)
        raise ArgumentError, 'delayed_start not supported on Windows 2003 and earlier editions'
      end

      service = opts.delete('service_name')
      host = opts.delete('host')

      raise TypeError unless service.is_a?(String)
      raise TypeError unless host.is_a?(String) if host

      begin
        handle_scm = OpenSCManager(host, nil, SC_MANAGER_CONNECT)

        FFI.raise_windows_error('OpenSCManager') if handle_scm == 0

        desired_access = SERVICE_CHANGE_CONFIG

        if opts['failure_actions']
          desired_access |= SERVICE_START
        end

        handle_scs = OpenService(
          handle_scm,
          service,
          desired_access
        )

        FFI.raise_windows_error('OpenService') if handle_scs == 0

        dependencies = opts['dependencies']

        if dependencies && !dependencies.empty?
          unless dependencies.is_a?(Array) || dependencies.is_a?(String)
            raise TypeError, 'dependencies must be a string or array'
          end

          if dependencies.is_a?(Array)
            dependencies = dependencies.join("\000")
          end

          dependencies += "\000"
        end

        bool = ChangeServiceConfig(
          handle_scs,
          opts['service_type'],
          opts['start_type'],
          opts['error_control'],
          opts['binary_path_name'],
          opts['load_order_group'],
          nil,
          dependencies,
          opts['service_start_name'],
          opts['password'],
          opts['display_name']
        )

        FFI.raise_windows_error('ChangeServiceConfig') unless bool

        if opts['description']
          description = SERVICE_DESCRIPTION.new
          description[:lpDescription] = FFI::MemoryPointer.from_string(opts['description'])

          bool = ChangeServiceConfig2(
            handle_scs,
            SERVICE_CONFIG_DESCRIPTION,
            description
          )

          FFI.raise_windows_error('ChangeServiceConfig2') unless bool
        end

        if windows_version >= 6 && opts['delayed_start']
          delayed_start = SERVICE_DELAYED_AUTO_START_INFO.new
          delayed_start[:fDelayedAutostart] = opts['delayed_start']

          bool = ChangeServiceConfig2(
            handle_scs,
            SERVICE_CONFIG_DELAYED_AUTO_START_INFO,
            delayed_start
          )

          FFI.raise_windows_error('ChangeServiceConfig2') unless bool
        end

        if opts['failure_reset_period'] || opts['failure_reboot_message'] ||
           opts['failure_command'] || opts['failure_actions']
        then
          configure_failure_actions(handle_scs, opts)
        end
      ensure
        CloseServiceHandle(handle_scs) if handle_scs && handle_scs > 0
        CloseServiceHandle(handle_scm) if handle_scm && handle_scm > 0
      end

      self
    end

    # Returns whether or not +service+ exists on +host+ or localhost, if
    # no host is specified.
    #
    # Example:
    #
    # Service.exists?('W32Time') => true
    #
    def self.exists?(service, host=nil)
      bool = false

      begin
        handle_scm = OpenSCManager(host, nil, SC_MANAGER_ENUMERATE_SERVICE)

        FFI.raise_windows_error('OpenSCManager') if handle_scm == 0

        handle_scs = OpenService(handle_scm, service, SERVICE_QUERY_STATUS)
        bool = true if handle_scs > 0
      ensure
        CloseServiceHandle(handle_scm) if handle_scm && handle_scm > 0
        CloseServiceHandle(handle_scs) if handle_scs && handle_scs > 0
      end

      bool
    end

    # Returns the display name of the specified service name, i.e. the string
    # displayed in the Services GUI. Raises a Service::Error if the service
    # name cannot be found.
    #
    # If a +host+ is provided, the information will be retrieved from that
    # host. Otherwise, the information is pulled from the local host (the
    # default behavior).
    #
    # Example:
    #
    # Service.get_display_name('W32Time') => 'Windows Time'
    #
    def self.get_display_name(service, host=nil)
      handle_scm = OpenSCManager(host, nil, SC_MANAGER_CONNECT)

      FFI.raise_windows_error('OpenSCManager') if handle_scm == 0

      display_name = FFI::MemoryPointer.new(260)
      display_size  = FFI::MemoryPointer.new(:ulong)
      display_size.write_ulong(display_name.size)

      begin
        bool = GetServiceDisplayName(
          handle_scm,
          service,
          display_name,
          display_size
        )


        FFI.raise_windows_error('OpenSCManager') unless bool
      ensure
        CloseServiceHandle(handle_scm)
      end

      display_name.read_string
    end

    # Returns the service name of the specified service from the provided
    # +display_name+. Raises a Service::Error if the +display_name+ cannote
    # be found.
    #
    # If a +host+ is provided, the information will be retrieved from that
    # host. Otherwise, the information is pulled from the local host (the
    # default behavior).
    #
    # Example:
    #
    # Service.get_service_name('Windows Time') => 'W32Time'
    #
    def self.get_service_name(display_name, host=nil)
      handle_scm = OpenSCManager(host, nil, SC_MANAGER_CONNECT)

      FFI.raise_windows_error('OpenSCManager') if handle_scm == 0

      service_name = FFI::MemoryPointer.new(260)
      service_size = FFI::MemoryPointer.new(:ulong)
      service_size.write_ulong(service_name.size)

      begin
        bool = GetServiceKeyName(
          handle_scm,
          display_name,
          service_name,
          service_size
        )

        FFI.raise_windows_error('GetServiceKeyName') unless bool
      ensure
        CloseServiceHandle(handle_scm)
      end

      service_name.read_string
    end

    # Attempts to start the named +service+ on +host+, or the local machine
    # if no host is provided. If +args+ are provided, they are passed to the
    # Daemon#service_main method.
    #
    # Examples:
    #
    #    # Start 'SomeSvc' on the local machine
    #    Service.start('SomeSvc', nil) => self
    #
    #    # Start 'SomeSvc' on host 'foo', passing 'hello' as an argument
    #    Service.start('SomeSvc', 'foo', 'hello') => self
    #
    def self.start(service, host=nil, *args)
      handle_scm = OpenSCManager(host, nil, SC_MANAGER_CONNECT)

      FFI.raise_windows_error('OpenSCManager') if handle_scm == 0

      begin
        handle_scs = OpenService(handle_scm, service, SERVICE_START)

        FFI.raise_windows_error('OpenService') if handle_scs == 0

        num_args = 0

        if args.empty?
          args = nil
        else
          str_ptrs = []
          num_args = args.size

          args.each{ |string|
            str_ptrs << FFI::MemoryPointer.from_string(string)
          }

          str_ptrs << nil

          vector = FFI::MemoryPointer.new(:pointer, str_ptrs.size)

          str_ptrs.each_with_index{ |p, i|
            vector[i].put_pointer(0, p)
          }
        end

        unless StartService(handle_scs, num_args, vector)
          FFI.raise_windows_error('StartService')
        end

      ensure
        CloseServiceHandle(handle_scs) if handle_scs && handle_scs > 0
        CloseServiceHandle(handle_scm)
      end

      self
    end

    # Stops a the given +service+ on +host+, or the local host if no host
    # is specified. Returns self.
    #
    # Note that attempting to stop an already stopped service raises
    # Service::Error.
    #
    # Example:
    #
    #    Service.stop('W32Time') => self
    #
    def self.stop(service, host=nil)
      service_signal = SERVICE_STOP
      control_signal = SERVICE_CONTROL_STOP
      send_signal(service, host, service_signal, control_signal)
      self
    end

    # Pauses the given +service+ on +host+, or the local host if no host
    # is specified. Returns self
    #
    # Note that pausing a service that is already paused will have
    # no effect and it will not raise an error.
    #
    # Be aware that not all services are configured to accept a pause
    # command. Attempting to pause a service that isn't setup to receive
    # a pause command will raise an error.
    #
    # Example:
    #
    #    Service.pause('Schedule') => self
    #
    def self.pause(service, host=nil)
      service_signal = SERVICE_PAUSE_CONTINUE
      control_signal = SERVICE_CONTROL_PAUSE
      send_signal(service, host, service_signal, control_signal)
      self
    end

    # Resume the given +service+ on +host+, or the local host if no host
    # is specified. Returns self.
    #
    # Note that resuming a service that's already running will have no
    # effect and it will not raise an error.
    #
    # Example:
    #
    #    Service.resume('Schedule') => self
    #
    def self.resume(service, host=nil)
      service_signal = SERVICE_PAUSE_CONTINUE
      control_signal = SERVICE_CONTROL_CONTINUE
      send_signal(service, host, service_signal, control_signal)
      self
    end

    # Deletes the specified +service+ from +host+, or the local host if
    # no host is specified. Returns self.
    #
    # Technical note. This method is not instantaneous. The service is first
    # marked for deletion from the service control manager database. Then all
    # handles to the service are closed. Then an attempt to stop the service
    # is made. If the service cannot be stopped, the service control manager
    # database entry is removed when the system is restarted.
    #
    # Example:
    #
    #   Service.delete('SomeService') => self
    #
    def self.delete(service, host=nil)
      handle_scm = OpenSCManager(host, nil, SC_MANAGER_CREATE_SERVICE)

      FFI.raise_windows_error('OpenSCManager') if handle_scm == 0

      begin
        handle_scs = OpenService(handle_scm, service, DELETE)

        FFI.raise_windows_error('OpenService') if handle_scs == 0

        unless DeleteService(handle_scs)
          FFI.raise_windows_error('DeleteService')
        end
      ensure
        CloseServiceHandle(handle_scs) if handle_scs && handle_scs > 0
        CloseServiceHandle(handle_scm)
      end

      self
    end

    # Returns a ServiceConfigInfo struct containing the configuration
    # information about +service+ on +host+, or the local host if no
    # host is specified.
    #
    # Example:
    #
    #   Service.config_info('W32Time') => <struct ServiceConfigInfo ...>
    #--
    # This contains less information that the ServiceInfo struct that
    # is returned with the Service.services method, but is faster for
    # looking up basic information for a single service.
    #
    def self.config_info(service, host=nil)
      raise TypeError if host && !host.is_a?(String)

      handle_scm = OpenSCManager(host, nil, SC_MANAGER_ENUMERATE_SERVICE)

      FFI.raise_windows_error('OpenSCManager') if handle_scm == 0

      begin
        handle_scs = OpenService(handle_scm, service, SERVICE_QUERY_CONFIG)

        FFI.raise_windows_error('OpenService') if handle_scs == 0

        # First, get the buf size needed
        bytes = FFI::MemoryPointer.new(:ulong)

        bool = QueryServiceConfig(handle_scs, nil, 0, bytes)

        if !bool && FFI.errno != ERROR_INSUFFICIENT_BUFFER
          FFI.raise_windows_error('QueryServiceConfig')
        end

        buf = FFI::MemoryPointer.new(:char, bytes.read_ulong)
        bytes = FFI::MemoryPointer.new(:ulong)

        bool = QueryServiceConfig(handle_scs, buf, buf.size, bytes)

        struct = QUERY_SERVICE_CONFIG.new(buf) # cast the buffer

        FFI.raise_windows_error('QueryServiceConfig') unless bool
      ensure
        CloseServiceHandle(handle_scs) if handle_scs && handle_scs > 0
        CloseServiceHandle(handle_scm)
      end

      ConfigStruct.new(
        get_service_type(struct[:dwServiceType]),
        get_start_type(struct[:dwStartType]),
        get_error_control(struct[:dwErrorControl]),
        struct[:lpBinaryPathName].read_string,
        struct[:lpLoadOrderGroup].read_string,
        struct[:dwTagId],
        struct[:lpDependencies].read_array_of_null_separated_strings,
        struct[:lpServiceStartName].read_string,
        struct[:lpDisplayName].read_string
      )
    end

    # Returns a ServiceStatus struct indicating the status of service +name+
    # on +host+, or the localhost if none is provided.
    #
    # Example:
    #
    # Service.status('W32Time') => <struct Struct::ServiceStatus ...>
    #
    def self.status(service, host=nil)
      handle_scm = OpenSCManager(host, nil, SC_MANAGER_ENUMERATE_SERVICE)

      FFI.raise_windows_error('OpenSCManager') if handle_scm == 0

      begin
        handle_scs = OpenService(
          handle_scm,
          service,
          SERVICE_QUERY_STATUS
        )

        FFI.raise_windows_error('OpenService') if handle_scs == 0

        # SERVICE_STATUS_PROCESS struct
        status = SERVICE_STATUS_PROCESS.new
        bytes  = FFI::MemoryPointer.new(:ulong)

        bool = QueryServiceStatusEx(
          handle_scs,
          SC_STATUS_PROCESS_INFO,
          status,
          status.size,
          bytes
        )

        FFI.raise_windows_error('QueryServiceStatusEx') unless bool

        service_type  = get_service_type(status[:dwServiceType])
        current_state = get_current_state(status[:dwCurrentState])
        controls      = get_controls_accepted(status[:dwControlsAccepted])
        interactive   = status[:dwServiceType] & SERVICE_INTERACTIVE_PROCESS > 0

        # Note that the pid and service flags will always return 0 if you're
        # on Windows NT 4 or using a version of Ruby compiled with VC++ 6
        # or earlier.
        #
        status_struct = StatusStruct.new(
          service_type,
          current_state,
          controls,
          status[:dwWin32ExitCode],
          status[:dwServiceSpecificExitCode],
          status[:dwCheckPoint],
          status[:dwWaitHint],
          interactive,
          status[:dwProcessId],
          status[:dwServiceFlags]
        )
      ensure
        CloseServiceHandle(handle_scs) if handle_scs && handle_scs > 0
        CloseServiceHandle(handle_scm)
      end

      status_struct
    end

    # Enumerates over a list of service types on +host+, or the local
    # machine if no host is specified, yielding a ServiceInfo struct for
    # each service.
    #
    # If a +group+ is specified, then only those services that belong to
    # that load order group are enumerated. If an empty string is provided,
    # then only services that do not belong to any group are enumerated. If
    # this parameter is nil (the default), group membership is ignored and
    # all services are enumerated. This value is not case sensitive.
    #
    # Examples:
    #
    #    # Enumerate over all services on the localhost
    #    Service.services{ |service| p service }
    #
    #    # Enumerate over all services on a remote host
    #    Service.services('some_host'){ |service| p service }
    #
    #    # Enumerate over all 'network' services locally
    #    Service.services(nil, 'network'){ |service| p service }
    #
    def self.services(host=nil, group=nil)
      unless host.nil?
        raise TypeError unless host.is_a?(String) # Avoid strange errors
      end

      unless group.nil?
        raise TypeError unless group.is_a?(String) # Avoid strange errors
      end

      handle_scm = OpenSCManager(host, nil, SC_MANAGER_ENUMERATE_SERVICE)

      FFI.raise_windows_error('OpenSCManager') if handle_scm == 0

      bytes_needed      = FFI::MemoryPointer.new(:ulong)
      services_returned = FFI::MemoryPointer.new(:ulong)
      resume_handle     = FFI::MemoryPointer.new(:ulong)

      begin
        # The first call is used to determine the required buffer size
        bool = EnumServicesStatusEx(
          handle_scm,
          SC_ENUM_PROCESS_INFO,
          SERVICE_WIN32 | SERVICE_DRIVER,
          SERVICE_STATE_ALL,
          nil,
          0,
          bytes_needed,
          services_returned,
          resume_handle,
          group
        )

        if !bool && FFI.errno == ERROR_MORE_DATA
          service_buf = FFI::MemoryPointer.new(:char, bytes_needed.read_ulong)
        else
          FFI.raise_windows_error('EnumServiceStatusEx')
        end

        bool = EnumServicesStatusEx(
          handle_scm,
          SC_ENUM_PROCESS_INFO,
          SERVICE_WIN32 | SERVICE_DRIVER,
          SERVICE_STATE_ALL,
          service_buf,
          service_buf.size,
          bytes_needed,
          services_returned,
          resume_handle,
          group
        )

        FFI.raise_windows_error('EnumServiceStatusEx') unless bool

        num_services = services_returned.read_ulong

        services_array = [] unless block_given?

        1.upto(num_services){ |num|
          # Cast the buffer
          struct = ENUM_SERVICE_STATUS_PROCESS.new(service_buf)

          service_name = struct[:lpServiceName].read_string
          display_name = struct[:lpDisplayName].read_string

          service_type  = get_service_type(struct[:ServiceStatusProcess][:dwServiceType])
          current_state = get_current_state(struct[:ServiceStatusProcess][:dwCurrentState])
          controls      = get_controls_accepted(struct[:ServiceStatusProcess][:dwControlsAccepted])

          interactive   = struct[:ServiceStatusProcess][:dwServiceType] & SERVICE_INTERACTIVE_PROCESS > 0
          win_exit_code = struct[:ServiceStatusProcess][:dwWin32ExitCode]
          ser_exit_code = struct[:ServiceStatusProcess][:dwServiceSpecificExitCode]
          check_point   = struct[:ServiceStatusProcess][:dwCheckPoint]
          wait_hint     = struct[:ServiceStatusProcess][:dwWaitHint]
          pid           = struct[:ServiceStatusProcess][:dwProcessId]
          service_flags = struct[:ServiceStatusProcess][:dwServiceFlags]

          begin
            handle_scs = OpenService(
              handle_scm,
              service_name,
              SERVICE_QUERY_CONFIG
            )

            FFI.raise_windows_error('OpenService') if handle_scs == 0

            config_struct = get_config_info(handle_scs)

            if config_struct != ERROR_FILE_NOT_FOUND
              binary_path = config_struct[:lpBinaryPathName].read_string
              load_order  = config_struct[:lpLoadOrderGroup].read_string
              start_name  = config_struct[:lpServiceStartName].read_string
              tag_id      = config_struct[:dwTagId]

              start_type = get_start_type(config_struct[:dwStartType])
              error_ctrl = get_error_control(config_struct[:dwErrorControl])

              deps = config_struct[:lpDependencies].read_array_of_null_separated_strings

              begin
                buf = get_config2_info(handle_scs, SERVICE_CONFIG_DESCRIPTION)

                if buf.is_a?(Fixnum) || buf.read_pointer.null?
                  description = ''
                else
                  description = buf.read_pointer.read_string
                end
              rescue
                # While being annoying, not being able to get a description is not exceptional
                warn "WARNING: Failed to retreive description for the #{service_name} service."
                description = ''
              end

              delayed_start = false
              # delayed_start can only be read from the service after 2003 / XP
              if windows_version >= 6
                delayed_start_buf = get_config2_info(handle_scs, SERVICE_CONFIG_DELAYED_AUTO_START_INFO)

                if delayed_start_buf.is_a?(FFI::MemoryPointer)
                  delayed_start_info = SERVICE_DELAYED_AUTO_START_INFO.new(delayed_start_buf)
                  delayed_start = delayed_start_info[:fDelayedAutostart]
                end
              end
            else
              msg = "WARNING: The registry entry for the #{service_name} "
              msg += "service could not be found."
              warn msg

              binary_path = nil
              load_order  = nil
              start_name  = nil
              start_type  = nil
              error_ctrl  = nil
              tag_id      = nil
              deps        = nil
              description = nil
            end

            buf2 = get_config2_info(handle_scs, SERVICE_CONFIG_FAILURE_ACTIONS)

            if buf2.is_a?(FFI::MemoryPointer)
              fail_struct = SERVICE_FAILURE_ACTIONS.new(buf2)

              reset_period = fail_struct[:dwResetPeriod]
              num_actions  = fail_struct[:cActions]

              if fail_struct[:lpRebootMsg].null?
                reboot_msg = nil
              else
                reboot_msg = fail_struct[:lpRebootMsg].read_string
              end

              if fail_struct[:lpCommand].null?
                command = nil
              else
                command = fail_struct[:lpCommand].read_string
              end

              actions = nil

              if num_actions > 0
                action_ptr = fail_struct[:lpsaActions]

                actions = {}

                num_actions.times{ |n|
                  sc_action = SC_ACTION.new(action_ptr[n])
                  delay = sc_action[:Delay]
                  action_type = get_action_type(sc_action[:Type])
                  actions[n+1] = {:action_type => action_type, :delay => delay}
                }
              end
            else
              reset_period = nil
              reboot_msg   = nil
              command      = nil
              actions      = nil
            end
          ensure
            CloseServiceHandle(handle_scs) if handle_scs > 0
          end

          struct = ServiceStruct.new(
            service_name,
            display_name,
            service_type,
            current_state,
            controls,
            win_exit_code,
            ser_exit_code,
            check_point,
            wait_hint,
            binary_path,
            start_type,
            error_ctrl,
            load_order,
            tag_id,
            start_name,
            deps,
            description,
            interactive,
            pid,
            service_flags,
            reset_period,
            reboot_msg,
            command,
            num_actions,
            actions,
            delayed_start
          )

          if block_given?
             yield struct
          else
             services_array << struct
          end

          service_buf += ENUM_SERVICE_STATUS_PROCESS.size
        }
      ensure
        CloseServiceHandle(handle_scm)
      end

      block_given? ? nil : services_array
    end

    private

    # Configures failure actions for a given service.
    #
    def self.configure_failure_actions(handle_scs, opts)
      if opts['failure_actions']
        token_handle = FFI::MemoryPointer.new(:ulong)

        bool = OpenProcessToken(
          GetCurrentProcess(),
          TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY,
          token_handle
        )

        unless bool
          error = FFI.errno
          CloseServiceHandle(handle_scs)
          raise SystemCallError.new('OpenProcessToken', error)
        end

        token_handle = token_handle.read_ulong

        # Get the LUID for shutdown privilege.
        luid = LUID.new

        unless LookupPrivilegeValue('', 'SeShutdownPrivilege', luid)
          error = FFI.errno
          CloseServiceHandle(handle_scs)
          raise SystemCallError.new('LookupPrivilegeValue', error)
        end

        luid_and_attrs = LUID_AND_ATTRIBUTES.new
        luid_and_attrs[:Luid] = luid
        luid_and_attrs[:Attributes] = SE_PRIVILEGE_ENABLED

        tkp = TOKEN_PRIVILEGES.new
        tkp[:PrivilegeCount] = 1
        tkp[:Privileges][0] = luid_and_attrs

        # Enable shutdown privilege in access token of this process
        bool = AdjustTokenPrivileges(
          token_handle,
          false,
          tkp,
          tkp.size,
          nil,
          nil
        )

        unless bool
          error = FFI.errno
          CloseServiceHandle(handle_scs)
          raise SystemCallError.new('AdjustTokenPrivileges', error)
        end
      end

      sfa = SERVICE_FAILURE_ACTIONS.new

      if opts['failure_reset_period']
        sfa[:dwResetPeriod] = opts['failure_reset_period']
      end

      if opts['failure_reboot_message']
        sfa[:lpRebootMsg] = FFI::MemoryPointer.from_string(opts['failure_reboot_message'])
      end

      if opts['failure_command']
        sfa[:lpCommand] = FFI::MemoryPointer.from_string(opts['failure_command'])
      end

      if opts['failure_actions']
        action_size = opts['failure_actions'].size
        action_ptr = FFI::MemoryPointer.new(SC_ACTION, action_size)

        actions = action_size.times.collect do |i|
          SC_ACTION.new(action_ptr + i * SC_ACTION.size)
        end

        opts['failure_actions'].each_with_index{ |action, i|
          actions[i][:Type] = action
          actions[i][:Delay] = opts['failure_delay']
        }

        sfa[:cActions] = action_size
        sfa[:lpsaActions] = action_ptr
      end

      bool = ChangeServiceConfig2(
        handle_scs,
        SERVICE_CONFIG_FAILURE_ACTIONS,
        sfa
      )

      unless bool
        error = FFI.errno
        CloseServiceHandle(handle_scs)
        raise SystemCallError.new('ChangeServiceConfig2', error)
      end
    end

    # Returns a human readable string indicating the action type.
    #
    def self.get_action_type(action_type)
      case action_type
        when SC_ACTION_NONE
          'none'
        when SC_ACTION_REBOOT
          'reboot'
        when SC_ACTION_RESTART
          'restart'
        when SC_ACTION_RUN_COMMAND
          'command'
        else
          'unknown'
      end
    end

    # Shortcut for QueryServiceConfig. Returns the buffer. In rare cases
    # the underlying registry entry may have been deleted, but the service
    # still exists. In that case, the ERROR_FILE_NOT_FOUND value is returned
    # instead.
    #
    def self.get_config_info(handle)
      bytes_needed = FFI::MemoryPointer.new(:ulong)

      # First attempt at QueryServiceConfig is to get size needed
      bool = QueryServiceConfig(handle, nil, 0, bytes_needed)

      if !bool && FFI.errno == ERROR_INSUFFICIENT_BUFFER
        config_buf = FFI::MemoryPointer.new(:char, bytes_needed.read_ulong)
      elsif FFI.errno == ERROR_FILE_NOT_FOUND
        return FFI.errno
      else
        error = FFI.errno
        CloseServiceHandle(handle)
        FFI.raise_windows_error('QueryServiceConfig', error)
      end

      bytes_needed.clear

      # Second attempt at QueryServiceConfig gets the actual info
      begin
        bool = QueryServiceConfig(
          handle,
          config_buf,
          config_buf.size,
          bytes_needed
        )

        FFI.raise_windows_error('QueryServiceConfig') unless bool
      ensure
        CloseServiceHandle(handle) unless bool
      end

      QUERY_SERVICE_CONFIG.new(config_buf) # cast the buffer
    end

    # Shortcut for QueryServiceConfig2. Returns the buffer.
    #
    def self.get_config2_info(handle, info_level)
      bytes_needed = FFI::MemoryPointer.new(:ulong)

      # First attempt at QueryServiceConfig2 is to get size needed
      bool = QueryServiceConfig2(handle, info_level, nil, 0, bytes_needed)

      err_num = FFI.errno

      # This is a bit hacky since it means we have to check the type of value
      # we get back, but we don't always want to raise an error either,
      # depending on what we're trying to get at.
      #
      if !bool && err_num == ERROR_INSUFFICIENT_BUFFER
        config2_buf = FFI::MemoryPointer.new(:char, bytes_needed.read_ulong)
      elsif [ERROR_FILE_NOT_FOUND, ERROR_RESOURCE_TYPE_NOT_FOUND, ERROR_RESOURCE_NAME_NOT_FOUND].include?(err_num)
        return err_num
      else
        CloseServiceHandle(handle)
        FFI.raise_windows_error('QueryServiceConfig2', err_num)
      end

      bytes_needed.clear

      # Second attempt at QueryServiceConfig2 gets the actual info
      begin
        bool = QueryServiceConfig2(
          handle,
          info_level,
          config2_buf,
          config2_buf.size,
          bytes_needed
        )

        FFI.raise_windows_error('QueryServiceConfig2') unless bool
      ensure
        CloseServiceHandle(handle) unless bool
      end

      config2_buf
    end

    # Returns a human readable string indicating the error control
    #
    def self.get_error_control(error_control)
      case error_control
        when SERVICE_ERROR_CRITICAL
          'critical'
        when SERVICE_ERROR_IGNORE
          'ignore'
        when SERVICE_ERROR_NORMAL
          'normal'
        when SERVICE_ERROR_SEVERE
          'severe'
        else
          nil
      end
    end

    # Returns a human readable string indicating the start type.
    #
    def self.get_start_type(start_type)
      case start_type
        when SERVICE_AUTO_START
          'auto start'
        when SERVICE_BOOT_START
          'boot start'
        when SERVICE_DEMAND_START
          'demand start'
        when SERVICE_DISABLED
          'disabled'
        when SERVICE_SYSTEM_START
          'system start'
        else
          nil
      end
    end

    # Returns an array of human readable strings indicating the controls
    # that the service accepts.
    #
    def self.get_controls_accepted(controls)
      array = []

      if controls & SERVICE_ACCEPT_NETBINDCHANGE > 0
        array << 'netbind change'
      end

      if controls & SERVICE_ACCEPT_PARAMCHANGE > 0
        array << 'param change'
      end

      if controls & SERVICE_ACCEPT_PAUSE_CONTINUE > 0
        array << 'pause continue'
      end

      if controls & SERVICE_ACCEPT_SHUTDOWN > 0
        array << 'shutdown'
      end

      if controls & SERVICE_ACCEPT_PRESHUTDOWN > 0
        array << 'pre-shutdown'
      end

      if controls & SERVICE_ACCEPT_STOP > 0
        array << 'stop'
      end

      if controls & SERVICE_ACCEPT_HARDWAREPROFILECHANGE > 0
        array << 'hardware profile change'
      end

      if controls & SERVICE_ACCEPT_POWEREVENT > 0
        array << 'power event'
      end

      if controls & SERVICE_ACCEPT_SESSIONCHANGE > 0
        array << 'session change'
      end

      array
    end

    # Converts a service state numeric constant into a readable string.
    #
    def self.get_current_state(state)
      case state
        when SERVICE_CONTINUE_PENDING
          'continue pending'
        when SERVICE_PAUSE_PENDING
          'pause pending'
        when SERVICE_PAUSED
          'paused'
        when SERVICE_RUNNING
          'running'
        when SERVICE_START_PENDING
          'start pending'
        when SERVICE_STOP_PENDING
          'stop pending'
        when SERVICE_STOPPED
          'stopped'
        else
          nil
      end
    end

    # Converts a service type numeric constant into a human readable string.
    #
    def self.get_service_type(service_type)
      case service_type
        when SERVICE_FILE_SYSTEM_DRIVER
          'file system driver'
        when SERVICE_KERNEL_DRIVER
          'kernel driver'
        when SERVICE_WIN32_OWN_PROCESS
          'own process'
        when SERVICE_WIN32_SHARE_PROCESS
          'share process'
        when SERVICE_RECOGNIZER_DRIVER
          'recognizer driver'
        when SERVICE_DRIVER
          'driver'
        when SERVICE_WIN32
          'win32'
        when SERVICE_TYPE_ALL
          'all'
        when SERVICE_INTERACTIVE_PROCESS | SERVICE_WIN32_OWN_PROCESS
          'own process, interactive'
        when SERVICE_INTERACTIVE_PROCESS | SERVICE_WIN32_SHARE_PROCESS
          'share process, interactive'
        else
          nil
      end
    end

    # A shortcut method that simplifies the various service control methods.
    #
    def self.send_signal(service, host, service_signal, control_signal)
      handle_scm = OpenSCManager(host, nil, SC_MANAGER_CONNECT)

      FFI.raise_windows_error('OpenSCManager') if handle_scm == 0

      begin
        handle_scs = OpenService(handle_scm, service, service_signal)

        FFI.raise_windows_error('OpenService') if handle_scs == 0

        status = SERVICE_STATUS.new

        unless ControlService(handle_scs, control_signal, status)
          FFI.raise_windows_error('ControlService')
        end
      ensure
        CloseServiceHandle(handle_scs) if handle_scs && handle_scs > 0
        CloseServiceHandle(handle_scm) if handle_scm && handle_scm > 0
      end

      status
    end

    class << self
      alias create new
      alias getdisplayname get_display_name
      alias getservicename get_service_name

      @@win_ver = nil

      # Private method that returns the Windows major version number.
      def windows_version
        return @@win_ver if @@win_ver

        ver = OSVERSIONINFO.new
        ver[:dwOSVersionInfoSize] = ver.size

        unless GetVersionExW(ver)
          raise SystemCallError.new('GetVersionEx', FFI.errno)
        end

        @@win_ver = ver[:dwMajorVersion]
        @@win_ver
      end
    end
  end
end
