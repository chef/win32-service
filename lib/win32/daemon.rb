require 'windows/service'
require 'windows/thread'
require 'windows/synchronize'
require 'windows/event'
require 'windows/handle'
require 'windows/error'

module Win32
   class Daemon
      class Error < StandardError; end
      
      include Windows::Service
      include Windows::Thread
      include Windows::Synchronize
      include Windows::Event
      include Windows::Handle
      include Windows::Error
      
      VERSION = '0.6.1'
      
      # The Daemon has received a resume signal, but is not yet running
      CONTINUE_PENDING = 0x00000005
      
      # The Daemon is in an idle state
      IDLE = 0
      
      # The Daemon is stopped, i.e. not running
      STOPPED = 0x00000001
      
      # The Daemon has received a start signal, but is not yet running
      START_PENDING = 0x00000002
      
      # The Daemon has received a sto signal but is not yet stopped.
      STOP_PENDING = 0x00000003 
      
      # The Daemon is running normally
      RUNNING = 0x00000004
      
      # The Daemon has received a pause signal, but is not yet paused
      PAUSE_PENDING = 0x00000006                             
      
      # The Daemon is in a paused state
      PAUSED = 0x00000007
      
      # The current state of the service, e.g. RUNNING, PAUSED, etc.
      attr_reader :service_state
      
      # The name of the log file, if any, that STDOUT and STDERR are
      # automatically redirected to.
      attr_reader :log_file
      
      # The handle associated with the log file, if provided. You must close
      # this yourself as appropriate, typically in the service_stop hook.
      attr_reader :log_file_handle                            
    
      def initialize(log_file = nil)
         @critical_section = [0].pack('L')
         @service_state    = 0
         @start_event      = nil
         @stop_event       = nil
         @control_code     = 0
         @event_hook       = {}
         @status_handle    = 0
         @log_file         = log_file
         @log_file_handle  = nil
         
         # Up to the user to close it properly in service_stop
         if @log_file
            @log_file_handle = File.open(@log_file, 'a')
         end

         InitializeCriticalSection(@critical_section)
      end
      
      def mainloop
         if respond_to?(:service_stop)
            @event_hook[SERVICE_CONTROL_STOP] = method(:service_stop)
         end
         
         if respond_to?(:service_pause)
            @event_hook[SERVICE_CONTROL_PAUSE] = method(:service_pause) 
         end

         if respond_to?(:service_resume)
            @event_hook[SERVICE_CONTROL_CONTINUE] = method(:service_resume) 
         end

         if respond_to?(:service_interrogate)
            @event_hook[SERVICE_CONTROL_INTERROGATE] = method(:service_interrogate) 
         end

         if respond_to?(:service_shutdown)
            @event_hook[SERVICE_CONTROL_SHUTDOWN] = method(:service_shutdown) 
         end

         if respond_to?(:service_paramchange)
            @event_hook[SERVICE_CONTROL_PARAMCHANGE] = method(:service_paramchange) 
         end

         if respond_to?(:service_netbindadd)
            @event_hook[SERVICE_CONTROL_NETBINDADD] = method(:service_netbindadd) 
         end

         if respond_to?(:service_netbindremove)
            @event_hook[SERVICE_CONTROL_NETBINDREMOVE] = method(:service_netbindremove) 
         end

         if respond_to?(:service_netbindenable)
            @event_hook[SERVICE_CONTROL_NETBINDENABLE] = method(:service_netbindenable) 
         end

         if respond_to?(:service_netbinddisable)
            @event_hook[SERVICE_CONTROL_NETBINDDISABLE] = method(:service_netbinddisable) 
         end

         service_init if respond_to?(:service_init)

         start_event = CreateEvent(nil, true, false, nil)
         raise Error, get_last_error if start_event.nil?

         stop_event = CreateEvent(nil, true, false, nil)
         raise Error, get_last_error if stop_event.nil?

         stop_completed_event = CreateEvent(nil, true, false, nil)
         raise Error, get_last_error if stop_completed_event.nil?

         thread_id = [0].pack('L')
         thread = CreateThread(nil, 0, thread_proc, 0, 0, thread_id)

         events = [thread, start_event]

         while (index = WaitForMultipleObjects(2, events, false, 1000)) == WAIT_TIMEOUT
            # Wait for the Service_Main function to start the service or terminate
         end

         # Thread exited so the show is off
         if index == WAIT_OBJECT_0
            raise Error, 'Service_Main thread exited abnormally'
         end

         Thread.new{ Ruby_Service_Ctrl }
      end

      def running?
         [RUNNING, PAUSED, IDLE].include?(@service_state)        
      end
      
      # Shortcut for Daemon.new#mainloop
      def self.mainloop
         new.mainloop
      end
      
      alias state service_state
      
      private
      
      def Service_Main(argc, argv=[])
         service_name = argv.shift
         
         # Register the service ctrl handler.
         service_status_handle = RegisterServiceCtrlHandler(
            service_name,
            Service_Ctrl
         )
         
         # No service to stop, no service handle to notify, nothing to do
         # but exit at this point.
         return if service_status_handle == 0
         
         # Redirect STDIN, STDOUT and STDERR to the NUL device, or the log
         # file if provided, if they're still associated with a tty. This
         # helps avoid Errno::EBADF errors.       
         STDIN.reopen('NUL') if STDIN.tty?
         STDOUT.reopen(@log_file_handle || 'NUL') if STDOUT.tty?
         STDERR.reopen(@log_file_handle || 'NUL') if STDERR.tty?
         
         #The service has started.
         SetTheServiceStatus(SERVICE_RUNNING, NO_ERROR, 0, 0)
         SetEvent(hStartEvent);
 
         while(WaitForSingleObject(@stop_event, 1000) != WAIT_OBJECT_0)
            # Main loop for the service.
         end
         
         # Stop the service.
         SetTheServiceStatus(SERVICE_STOPPED, NO_ERROR, 0, 0)         
      end
      
      def Service_Event_Dispatch(func)
         self.send(:func)
      end
      
      def Ruby_Service_Ctrl
         while WaitForSingleObject(hStopEvent, 0) == WAIT_TIMEOUT
            RUBY_CRITICAL{
               if @control_code != 0
                  # TODO: finish
               end
            }
         end
      end
      
      def Service_Ctrl(ctrl_code)
         state = SERVICE_RUNNING
         RUBY_CRITICAL{ @control_code = ctrl_code }
         
         # TODO: What about other control codes?
         case ctrl_code
            when SERVICE_CONTROL_STOP, SERVICE_CONTROL_SHUTDOWN
               state = SERVICE_STOP_PENDING
            when SERVICE_CONTROL_PAUSE
               state = SERVICE_PAUSED # TODO: Or pending? verify
            when SERVICE_CONTROL_CONTINUE
               state = SERVICE_RUNNING
            else
               # TODO: Else what?
         end
         
         # Set the status of the service.
         SetTheServiceStatus(state, NO_ERROR, 0, 0);
         
         # Tell service_main thread to stop.
         if [SERVICE_CONTROL_STOP,SERVICE_CONTROL_SHUTDOWN].include?(ctrl_code)
            unless SetEvent(@stop_event)
                SetTheServiceStatus(SERVICE_STOPPED, GetLastError(), 0, 0)
            end
         end        
      end
      
      # Wraps SetServiceStatus.
      def SetTheServiceStatus(curr_state, exit_code, check_point, wait_hint)
         service_status = 0.chr * 28 # sizeof(SERVICE_STATUS)
         
         # Disable control requests until the service is started.
         if curr_state != SERVICE_START_PENDING
            val = SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_SHUTDOWN |
                  SERVICE_ACCEPT_PAUSE_CONTINUE | SERVICE_ACCEPT_SHUTDOWN
                  
            service_status[8,4] = [val].pack('L')
         end
         
         # Initialize service_status struct
         service_status[0,4]  = [SERVICE_WIN32_OWN_PROCESS].pack('L')
         service_status[4,4]  = [curr_state].pack('L')
         service_status[12,4] = [exit_code].pack('L')
         service_status[20,4] = [check_point].pack('L')
         service_status[24,4] = [wait_hint].pack('L')
         
         @service_state = curr_state
         
         # Send status of the service to the Service Controller.
         unless SetServiceStatus(@status_handle, service_status)
            SetEvent(@stop_event)
         end   
      end
   end
end
