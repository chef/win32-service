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
require 'socket'

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

    VERSION = '0.8.0'

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

    def mainloop
      gs = TCPserver.open(0)

      @end_event = CreateEvent(0, 0, 0, "end_event_#{gs.addr[1]}")

      if @end_event == 0
        raise Error, get_last_error
      end

      @stop_event = CreateEvent(0, 0, 0, "stop_event_#{gs.addr[1]}")

      if @stop_event == 0
        raise Error, get_last_error
      end

      @pause_event = CreateEvent(0, 0, 0, "pause_event_#{gs.addr[1]}")

      if @pause_event == 0
        raise Error, get_last_error
      end

      @resume_event = CreateEvent(0, 0, 0, "resume_event_#{gs.addr[1]}")

      if @resume_event == 0
        raise Error, get_last_error
      end

      service_init() if defined?(service_init)

      ruby = File.join(CONFIG['bindir'], 'ruby ').tr('/', '\\')
      path = File.dirname(__FILE__) + "//daemon0.rb #{gs.addr[1]}"

      Process.create(
        :app_name       => ruby + path,
        :creation_flags => Process::CREATE_NO_WINDOW
      )

      nsock = select([gs])
      s = gs.accept
      data = s.gets
      s.close

      data = data || ''
      argv = data.split(';')
      @service_name = argv[0]

      handles = [@stop_event, at pause_event, at resume_event]

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
