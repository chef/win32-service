require 'ffi'

module Windows
  module Structs
    extend FFI::Library

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
  end
end
