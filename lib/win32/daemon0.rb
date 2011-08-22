require 'windows/service'
require 'windows/thread'
require 'windows/synchronize'
require 'windows/handle'
require 'windows/error'
require 'windows/msvcrt/buffer'
require 'windows/msvcrt/string'
require 'win32/api'

include Windows::Service
include Windows::Thread
include Windows::Synchronize
include Windows::Handle
include Windows::Error
include Windows::MSVCRT::Buffer
include Windows::MSVCRT::String


# Wraps SetServiceStatus.
def set_the_service_statue(curr_state, exit_code, check_point, wait_hint)
  service_status = 0.chr * 28 # sizeof(SERVICE_STATUS)
  
  # Disable control requests until the service is started.
  if curr_state == SERVICE_START_PENDING
    val = 0
  else
    val = SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_SHUTDOWN |
          SERVICE_ACCEPT_PAUSE_CONTINUE | SERVICE_ACCEPT_SHUTDOWN
  end

  service_status[8,4] = [val].pack('L')
  
  # Initialize service_status struct
  service_status[0,4]  = [SERVICE_WIN32_OWN_PROCESS].pack('L')
  service_status[4,4]  = [curr_state].pack('L')
  service_status[12,4] = [exit_code].pack('L')
  service_status[20,4] = [check_point].pack('L')
  service_status[24,4] = [wait_hint].pack('L')
  
  service_state = curr_state
    
  # Send status of the service to the Service Controller.
  unless SetServiceStatus(@status_handle, service_status)
    SetEvent(@stop_event)
  end
end

begin 
  @arg_event = OpenEvent(EVENT_ALL_ACCESS, 0, "arg_event_#{ARGV[0]}")

  if @arg_event == 0
    raise Error, get_last_error
  end

  @end_event = OpenEvent(EVENT_ALL_ACCESS, 0, "end_event_#{ARGV[0]}")

  if @end_event == 0
    raise Error, get_last_error
  end

  @stop_event = OpenEvent(EVENT_ALL_ACCESS, 0, "stop_event_#{ARGV[0]}")

  if @stop_event == 0
    raise Error, get_last_error
  end

  @pause_event = OpenEvent(EVENT_ALL_ACCESS, 0, "pause_event_#{ARGV[0]}")

  if @pause_event == 0
    raise Error, get_last_error
  end

  @resume_event = OpenEvent(EVENT_ALL_ACCESS, 0, "resume_event_#{ARGV[0]}")

  if @resume_event == 0
    raise Error, get_last_error
  end
  
  
  service_ctrl = Win32::API::Callback.new('L', 'V') do |ctrl_code|
    state = SERVICE_RUNNING
    
    case ctrl_code
      when SERVICE_CONTROL_STOP
        state = SERVICE_STOP_PENDING
      when SERVICE_CONTROL_PAUSE
        state = SERVICE_PAUSED
        SetEvent(@pause_event)
      when SERVICE_CONTROL_CONTINUE
        state = SERVICE_RUNNING
        SetEvent(@resume_event)
    end
    
    # Set the status of the service.
    set_the_service_statue(state, NO_ERROR, 0, 0)

    # Tell service_main thread to stop.
    if [SERVICE_CONTROL_STOP].include?(ctrl_code)
      wait_result = WaitForSingleObject(@end_event, INFINITE)

      if wait_result != WAIT_OBJECT_0
        set_the_service_statue(SERVICE_STOPPED,GetLastError(),0,0)
      else
        set_the_service_statue(SERVICE_STOPPED,NO_ERROR,0,0)
      end

      SetEvent(@stop_event) 
      sleep 3
    end

  end
  
  svc_main = Win32::API::Callback.new('LL', 'I') do |argc, lpszargv|
    argv = []

    argc.times do |i|
      ptr = 0.chr * 4
      buf = 0.chr * 256
      memcpy(ptr,lpszargv+i*4,4)
      strcpy(buf,ptr.unpack('L').first)
      argv << buf.strip
    end

    service_name = argv[0]
    
    f = File.new(ENV['TEMP']+"\\daemon#{ARGV[0]}","w")
    f.print(argv.join(';'))
    f.close
    SetEvent(@arg_event)
  
    # Register the service ctrl handler.
    @status_handle = RegisterServiceCtrlHandler(
      service_name,service_ctrl
    )

    # No service to stop, no service handle to notify, nothing to do
    # but exit at this point.
    return false if @status_handle == 0
      
    #The service has started.
    set_the_service_statue(SERVICE_RUNNING, NO_ERROR, 0, 0)
    
    true
  end
  
  dispatch_table = [""].pack('p') + [svc_main.address].pack('L') + "\0"*8

  if(!StartServiceCtrlDispatcher(dispatch_table))
    File.open("c:\\win32_daemon0.log", "a+"){ |f|
      f.puts("StartServiceCtrlDispatcher Fail")
    }
  end
rescue Exception => err
  File.open("c:\\win32_daemon0.log", "a+"){ |f|
    f.puts(err.inspect)
  }
end
