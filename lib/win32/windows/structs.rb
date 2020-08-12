require 'ffi' unless defined?(FFI)

module Windows
  module ServiceStructs
    extend FFI::Library

    typedef :ulong, :dword

    class SERVICE_STATUS < FFI::Struct
      layout(
        :dwServiceType, :ulong,
        :dwCurrentState, :ulong,
        :dwControlsAccepted, :ulong,
        :dwWin32ExitCode, :ulong,
        :dwServiceSpecificExitCode, :ulong,
        :dwCheckPoint, :ulong,
        :dwWaitHint, :ulong
      )
    end

    class SERVICE_STATUS_PROCESS < FFI::Struct
      layout(
        :dwServiceType, :dword,
        :dwCurrentState, :dword,
        :dwControlsAccepted, :dword,
        :dwWin32ExitCode, :dword,
        :dwServiceSpecificExitCode, :dword,
        :dwCheckPoint, :dword,
        :dwWaitHint, :dword,
        :dwProcessId, :dword,
        :dwServiceFlags, :dword
      )
    end

    class SERVICE_DESCRIPTION < FFI::Struct
      layout(:lpDescription, :pointer)
    end

    class SERVICE_DELAYED_AUTO_START_INFO < FFI::Struct
      layout(:fDelayedAutostart, :int) # BOOL

      alias aset []=

      # Intercept the accessor so that we can handle either true/false or 1/0.
      # Since there is only one member, there's no need to check the key name.
      #
      def []=(key, value)
        [0, false].include?(value) ? aset(key, 0) : aset(key, 1)
      end
    end

    class QUERY_SERVICE_CONFIG < FFI::Struct
      layout(
        :dwServiceType, :dword,
        :dwStartType, :dword,
        :dwErrorControl, :dword,
        :lpBinaryPathName, :pointer,
        :lpLoadOrderGroup, :pointer,
        :dwTagId, :dword,
        :lpDependencies, :pointer,
        :lpServiceStartName, :pointer,
        :lpDisplayName, :pointer
      )

      def dependencies
        length = self[:lpServiceStartName].address - self[:lpDependencies].address - 1
        self[:lpDependencies].read_bytes(length).split(0.chr)
      end
    end

    class ENUM_SERVICE_STATUS_PROCESS < FFI::Struct
      layout(
        :lpServiceName, :pointer,
        :lpDisplayName, :pointer,
        :ServiceStatusProcess, SERVICE_STATUS_PROCESS
      )
    end

    class SC_ACTION < FFI::Struct
      layout(:Type, :int, :Delay, :dword)
    end

    class SERVICE_FAILURE_ACTIONS < FFI::Struct
      layout(
        :dwResetPeriod, :dword,
        :lpRebootMsg, :pointer,
        :lpCommand, :pointer,
        :cActions, :dword,
        :lpsaActions, :pointer # Array of SC_ACTION structs
      )
    end

    class SERVICE_TABLE_ENTRY < FFI::Struct
      layout(
        :lpServiceName, :pointer,
        :lpServiceProc, :pointer
      )
    end

    class LUID < FFI::Struct
      layout(
        :LowPart, :ulong,
        :HighPart, :long
      )
    end

    class LUID_AND_ATTRIBUTES < FFI::Struct
      layout(
        :Luid, LUID,
        :Attributes, :ulong
      )
    end

    class TOKEN_PRIVILEGES < FFI::Struct
      layout(
        :PrivilegeCount, :dword,
        :Privileges, [LUID_AND_ATTRIBUTES, 1]
      )
    end
  end
end
