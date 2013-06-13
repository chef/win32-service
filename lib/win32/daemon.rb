require File.join(File.dirname(__FILE__), 'windows', 'helper')
require File.join(File.dirname(__FILE__), 'windows', 'constants')
require File.join(File.dirname(__FILE__), 'windows', 'structs')
require File.join(File.dirname(__FILE__), 'windows', 'functions')

module Win32
  class Daemon
    include Windows::Constants
    include Windows::Structs
    include Windows::Functions

    extend Windows::Structs
    extend Windows::Functions

    def initialize
      @service_state = nil
      @service_status_handle = nil
      @stop_event = nil
      @start_event = nil
      @event_hooks
      @critical_section = FFI::MemoryPointer.new(:uintptr_t)
    end

    def mainloop
      STDIN.reopen("NUL") if STDIN.isatty
      STDOUT.reopen("NUL") if STDOUT.isatty
      STDERR.reopen("NUL") if STDOUT.isatty

      service_state = 0
    end

    private

    def service_ctrl(ctrl_code)
      state = SERVICE_RUNNING

      begin
        EnterCriticalSection(@critical_section)
        waiting_control_code = ctrl_code
      ensure
        LeaveCriticalSection(@critical_section)
      end

      case ctrl_code
        when SERVICE_CONTROL_STOP
          state = SERVICE_STOP_PENDING
        when SERVICE_CONTROL_SHUTDOWN
          state = SERVICE_STOP_PENDING
        when SERVICE_CONTROL_PAUSE
          state = SERVICE_PAUSED
        when SERVICE_CONTROL_CONTINUE
          state = SERVICE_RUNNING
      end

      set_service_status(state, NO_ERROR, 0, 0)

      if ctrl_code = SERVICE_CONTROL_STOP || SERVICE_CONTROL_SHUTDOWN
        unless SetEvent(@stop_event)
          set_service_status(SERVICE_STOPPED, FFI.errno, 0, 0)
        end
      end
    end

    def service_main(name, *args)
      @service_status_handle = RegisterServiceCtrlHandler(name, service_ctrl_func)

      strptrs = []

      args.each{ |str| strptrs << FFI::MemoryPointer.from_string(str) }

      strptrs << nil

      argv = FFI::MemoryPointer.new(:pointer, :strptrs.size)

      strptrs.each_with_index do |p, i|
        argv[i].put_pointer(0, p)
      end

      return if @service_status_handle == 0

      set_service_status(SERVICE_RUNNING, NO_ERROR, 0, 0)

      SetEvent(@start_event)

      while WaitForSingleObject(@stop_event, 1000) != WAIT_OBJECT_0
        # Do nothing
      end

      set_service_status(SERVICE_STOPPED, NO_ERROR, 0, 0)
    end

    # Create and initialize a SERVICE_STATUS struct and pass it to
    # the SetServiceStatus function. If that should fail for any reason,
    # then call the stop event.
    #
    def set_service_status(current_state, exit_code, check_point, wait_hint)
      status = SERVICE_STATUS.new

      if current_state == SERVICE_START_PENDING
        status[:dwControlsAccepted] = 0
      else
        status[:dwControlsAccepted] =
          SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_SHUTDOWN |
          SERVICE_ACCEPT_PAUSE_CONTINUE | SERVICE_ACCEPT_SHUTDOWN
      end

      status[:dwServiceType] = SERVICE_WIN32_OWN_PROCESS
      status[:dwServiceSpecificExitCode] = 0
      status[:dwCurrentState]  = current_state
      status[:dwWin32ExitCode] = exit_code
      status[:dwCheckPoint]    = check_point
      status[:dwWaitHint]      = wait_hint

      @service_state = current_state

      unless SetServiceStatus(@service_status_handle, status)
        SetEvent(@stop_event)
      end
    end
  end
end
