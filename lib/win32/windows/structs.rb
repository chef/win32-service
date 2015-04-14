require 'ffi'

module Windows
  module Structs
    extend FFI::Library

    typedef :uchar, :byte
    typedef :uint16, :word
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
      layout(:fDelayedAutostart, :bool)
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

    class OSVERSIONINFO < FFI::Struct
      layout(
        :dwOSVersionInfoSize, :dword,
        :dwMajorVersion, :dword,
        :dwMinorVersion, :dword,
        :dwBuildNumber, :dword,
        :dwPlatformId, :dword,
        :szCSDVersion, [:uint16, 128],
        :wServicePackMajor, :word,
        :wServicePackMinor, :word,
        :wSuiteMask, :word,
        :wProductType, :byte,
        :wReserved, :byte,
      )
    end
  end
end
