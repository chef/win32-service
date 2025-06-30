require "ffi" unless defined?(FFI)

module Windows
  module ServiceFunctions
    extend FFI::Library

    # Make FFI functions private
    module FFI::Library
      def attach_pfunc(*args)
        attach_function(*args)
        private args[0]
      end
    end

    typedef :ulong, :dword
    typedef :uintptr_t, :handle
    typedef :pointer, :ptr
    typedef :string, :str

    ffi_convention :stdcall

    ffi_lib :kernel32

    attach_pfunc :CloseHandle, [:handle], :bool
    attach_pfunc :CreateEvent, :CreateEventA, %i{ptr int int str}, :handle
    attach_pfunc :CreateThread, %i{ptr size_t ptr ptr dword ptr}, :handle, blocking: true
    attach_pfunc :EnterCriticalSection, [:ptr], :void
    attach_pfunc :FormatMessage, :FormatMessageA, %i{ulong ptr ulong ulong str ulong ptr}, :ulong
    attach_pfunc :GetCurrentProcess, [], :handle
    attach_pfunc :InitializeCriticalSection, [:ptr], :void
    attach_pfunc :LeaveCriticalSection, [:ptr], :void
    attach_pfunc :SetEvent, [:handle], :bool
    attach_pfunc :WaitForSingleObject, %i{handle dword}, :dword, blocking: true
    attach_pfunc :WaitForMultipleObjects, %i{dword ptr int dword}, :dword

    ffi_lib :advapi32

    callback :handler_ex, %i{ulong ulong ptr ptr}, :void

    attach_pfunc :AdjustTokenPrivileges, %i{handle int ptr dword ptr ptr}, :bool
    attach_pfunc :CloseServiceHandle, [:handle], :bool

    attach_pfunc :ChangeServiceConfig, :ChangeServiceConfigA,
      %i{handle dword dword dword str str ptr ptr str str str},
      :bool

    attach_pfunc :ChangeServiceConfig2, :ChangeServiceConfig2A, %i{handle dword ptr}, :bool

    attach_pfunc :CreateService, :CreateServiceA,
      %i{handle string string dword dword dword dword
       string string ptr pointer string string},
      :handle

    attach_pfunc :ControlService, %i{handle dword ptr}, :bool
    attach_pfunc :DeleteService, [:handle], :bool

    attach_pfunc :EnumServicesStatusEx, :EnumServicesStatusExA,
      %i{handle int dword dword ptr dword ptr ptr ptr string},
      :bool

    attach_pfunc :GetServiceDisplayName, :GetServiceDisplayNameA, %i{handle string ptr ptr}, :bool
    attach_pfunc :GetServiceKeyName, :GetServiceKeyNameA, %i{handle string ptr ptr}, :bool
    attach_pfunc :LookupPrivilegeValue, :LookupPrivilegeValueA, %i{string string ptr}, :bool
    attach_pfunc :OpenSCManager, :OpenSCManagerA, %i{ptr ptr dword}, :handle
    attach_pfunc :OpenProcessToken, %i{handle dword ptr}, :bool
    attach_pfunc :OpenService, :OpenServiceA, %i{handle string dword}, :handle
    attach_pfunc :QueryServiceConfig, :QueryServiceConfigA, %i{handle ptr dword ptr}, :bool
    attach_pfunc :QueryServiceConfig2, :QueryServiceConfig2A, %i{handle dword ptr dword ptr}, :bool
    attach_pfunc :QueryServiceStatusEx, %i{handle int ptr dword ptr}, :bool
    attach_pfunc :RegisterServiceCtrlHandlerEx, :RegisterServiceCtrlHandlerExA, %i{str handler_ex ptr}, :handle
    attach_pfunc :SetServiceStatus, %i{handle ptr}, :bool
    attach_pfunc :StartService, :StartServiceA, %i{handle dword ptr}, :bool
    attach_pfunc :StartServiceCtrlDispatcher, :StartServiceCtrlDispatcherA, [:ptr], :bool, blocking: true
  end
end
