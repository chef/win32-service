require 'windows/service'
require 'windows/thread'
require 'windows/synchronize'
require 'windows/handle'
require 'windows/error'
require 'windows/msvcrt/buffer'
require 'windows/msvcrt/string'
require 'win32/api'
require 'win32/process'
require 'win32/service'

module Win32
  class Daemon
    class Error < StandardError; end

    include Windows::Service
    include Windows::Thread
    include Windows::Synchronize
    include Windows::Handle
    include Windows::Error
    include Windows::MSVCRT::Buffer
    include Windows::MSVCRT::String

    VERSION = '0.8.1'

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
    attr_reader :state

    def initialize
       @critical_section = [0].pack('L')
       @service_state    = nil
       @start_event      = nil
       @stop_event       = nil
       @control_code     = 0
       @event_hooks      = {}
       @status_handle    = 0

    end

    def mainloop
      @arg_event = CreateEvent(0, 0, 0, "arg_event_#{Process.pid}")

      if @arg_event == 0
        raise Error, get_last_error
      end       

      @end_event = CreateEvent(0, 0, 0, "end_event_#{Process.pid}")

      if @end_event == 0
        raise Error, get_last_error
      end

      @stop_event = CreateEvent(0, 0, 0, "stop_event_#{Process.pid}")

      if @stop_event == 0
        raise Error, get_last_error
      end

      @pause_event = CreateEvent(0, 0, 0, "pause_event_#{Process.pid}")

      if @pause_event == 0
        raise Error, get_last_error
      end

      @resume_event = CreateEvent(0, 0, 0, "resume_event_#{Process.pid}")

      if @resume_event == 0
        raise Error, get_last_error
      end
        
      service_init() if defined?(service_init)

      tmpfile = ENV['TEMP']+"\\daemon#{Process.pid}"
      File.delete(tmpfile) if File.exist?(tmpfile)
      ruby = File.join(CONFIG['bindir'], 'ruby ').tr('/', '\\')
      path = File.dirname(__FILE__) + "//daemon0.rb #{Process.pid}"

      Process.create(
        :app_name       => ruby + path,
        :creation_flags => Process::CREATE_NO_WINDOW
      )

      wait_result = WaitForSingleObject(@arg_event, INFINITE)

      if wait_result == WAIT_FAILED
        error = 'WaitForSingleObject() failed: ' + get_last_error
        raise Error, error
      elsif File.exist?(tmpfile) && File.size(tmpfile)>0
        f = File.open(tmpfile)
        data = f.gets
        f.close
      else
        data = ''
      end

      data = data || ''
      argv = data.split(';')
      @service_name = argv[0]

      handles = [@stop_event, @pause_event, @resume_event]

      t = Thread.new {
        while(true) do    
          wait = WaitForMultipleObjects(
            handles.size,
            handles.pack('L*'),
            0,
            10
          )

          if wait >= WAIT_OBJECT_0 && wait <= WAIT_OBJECT_0 + handles.size - 1
            index = wait - WAIT_OBJECT_0
            case handles[index]
              when @stop_event
                service_stop() if defined?(service_stop)
                return
              when @pause_event
                service_pause() if defined?(service_pause)
              when @resume_event
                service_resume() if defined?(service_resume)
              end
            end
          end       
      }

      service_main(argv) if defined?(service_main)
      SetEvent(@end_event)
      t.join
    end

    def running?
      true if [RUNNING,START_PENDING].include?(state)
    end

    def state
      case Win32::Service.status(@service_name).current_state
        when 'running'
          return RUNNING
        when 'start pending'
          return START_PENDING
        when 'stopped'
          return STOPPED
        when 'paused'
          return PAUSED
      end

      return 0
    end

    # Shortcut for Daemon.new#mainloop
    def self.mainloop
      new.mainloop
    end
  end
end
