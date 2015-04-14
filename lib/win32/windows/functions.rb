require 'ffi'

module Windows
  module Functions
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
    attach_pfunc :CreateEvent, :CreateEventA, [:ptr, :bool, :bool, :str], :handle
    attach_pfunc :CreateThread, [:ptr, :size_t, :ptr, :ptr, :dword, :ptr], :handle, :blocking => true
    attach_pfunc :EnterCriticalSection, [:ptr], :void
    attach_pfunc :FormatMessage, :FormatMessageA, [:ulong, :ptr, :ulong, :ulong, :str, :ulong, :ptr], :ulong
    attach_pfunc :GetCurrentProcess, [], :handle
    attach_pfunc :InitializeCriticalSection, [:ptr], :void
    attach_pfunc :LeaveCriticalSection, [:ptr], :void
    attach_pfunc :SetEvent, [:handle], :bool
    attach_pfunc :WaitForSingleObject, [:handle, :dword], :dword, :blocking => true
    attach_pfunc :WaitForMultipleObjects, [:dword, :ptr, :bool, :dword], :dword

    attach_pfunc :GetVersionExW, [:ptr], :bool

    ffi_lib :advapi32

    callback :handler_ex, [:ulong, :ulong, :ptr, :ptr], :void

    attach_pfunc :AdjustTokenPrivileges, [:handle, :bool, :ptr, :dword, :ptr, :ptr], :bool
    attach_pfunc :CloseServiceHandle, [:handle], :bool

    attach_pfunc :ChangeServiceConfig, :ChangeServiceConfigA,
      [:handle, :dword, :dword, :dword, :str, :str, :ptr, :str, :str, :str, :str],
      :bool

    attach_pfunc :ChangeServiceConfig2, :ChangeServiceConfig2A, [:handle, :dword, :ptr], :bool

    attach_pfunc :CreateService, :CreateServiceA,
      [:handle, :string, :string, :dword, :dword, :dword, :dword,
       :string, :string, :ptr, :pointer, :string, :string],
       :handle

    attach_pfunc :ControlService, [:handle, :dword, :ptr], :bool
    attach_pfunc :DeleteService, [:handle], :bool

    attach_pfunc :EnumServicesStatusEx, :EnumServicesStatusExA,
      [:handle, :int, :dword, :dword, :ptr, :dword, :ptr, :ptr, :ptr, :string],
      :bool

    attach_pfunc :GetServiceDisplayName, :GetServiceDisplayNameA, [:handle, :string, :ptr, :ptr], :bool
    attach_pfunc :GetServiceKeyName, :GetServiceKeyNameA, [:handle, :string, :ptr, :ptr], :bool
    attach_pfunc :LookupPrivilegeValue, :LookupPrivilegeValueA, [:string, :string, :ptr], :bool
    attach_pfunc :OpenSCManager, :OpenSCManagerA, [:ptr, :ptr, :dword], :handle
    attach_pfunc :OpenProcessToken, [:handle, :dword, :ptr], :bool
    attach_pfunc :OpenService, :OpenServiceA, [:handle, :string, :dword], :handle
    attach_pfunc :QueryServiceConfig, :QueryServiceConfigA, [:handle, :ptr, :dword, :ptr], :bool
    attach_pfunc :QueryServiceConfig2, :QueryServiceConfig2A, [:handle, :dword, :ptr, :dword, :ptr], :bool
    attach_pfunc :QueryServiceStatusEx, [:handle, :int, :ptr, :dword, :ptr], :bool
    attach_pfunc :RegisterServiceCtrlHandlerEx, :RegisterServiceCtrlHandlerExA, [:str, :handler_ex, :ptr], :handle
    attach_pfunc :SetServiceStatus, [:handle, :ptr], :bool
    attach_pfunc :StartService, :StartServiceA, [:handle, :dword, :ptr], :bool
    attach_pfunc :StartServiceCtrlDispatcher, :StartServiceCtrlDispatcherA, [:ptr], :bool, :blocking => true
  end
end
