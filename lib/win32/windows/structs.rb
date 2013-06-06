require 'ffi'

module Windows
  module Structs
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
  end
end
