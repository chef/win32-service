require 'ffi'

module Windows
  module Functions
    extend FFI::Library

    typedef :ulong, :dword
    typedef :uintptr_t, :handle
    typedef :pointer, :ptr
    typedef :string, :str

    ffi_convention :stdcall

    ffi_lib :kernel32

    attach_function :CloseHandle, [:handle], :bool
    attach_function :CreateEvent, :CreateEventA, [:ptr, :bool, :bool, :str], :handle
    attach_function :CreateThread, [:ptr, :size_t, :ptr, :ptr, :dword, :ptr], :handle, :blocking => true
    attach_function :EnterCriticalSection, [:ptr], :void
    attach_function :FormatMessage, :FormatMessageA, [:ulong, :ptr, :ulong, :ulong, :str, :ulong, :ptr], :ulong
    attach_function :InitializeCriticalSection, [:ptr], :void
    attach_function :LeaveCriticalSection, [:ptr], :void
    attach_function :SetEvent, [:handle], :bool
    attach_function :WaitForSingleObject, [:handle, :dword], :dword, :blocking => true
    attach_function :WaitForMultipleObjects, [:dword, :ptr, :bool, :dword], :dword

    ffi_lib :advapi32

    callback :handler_ex, [:ulong, :ulong, :ptr, :ptr], :void

    attach_function :CloseServiceHandle, [:handle], :bool

    attach_function :ChangeServiceConfig, :ChangeServiceConfigA,
      [:handle, :dword, :dword, :dword, :str, :str, :ptr, :str, :str, :str, :str],
      :bool

    attach_function :ChangeServiceConfig2, :ChangeServiceConfig2A, [:handle, :dword, :ptr], :bool

    attach_function :CreateService, :CreateServiceA,
      [:handle, :string, :string, :dword, :dword, :dword, :dword,
       :string, :string, :ptr, :pointer, :string, :string],
       :handle

    attach_function :ControlService, [:handle, :dword, :ptr], :bool
    attach_function :DeleteService, [:handle], :bool

    attach_function :EnumServicesStatusEx, :EnumServicesStatusExA,
      [:handle, :int, :dword, :dword, :ptr, :dword, :ptr, :ptr, :ptr, :string],
      :bool

    attach_function :GetServiceDisplayName, :GetServiceDisplayNameA, [:handle, :string, :ptr, :ptr], :bool
    attach_function :GetServiceKeyName, :GetServiceKeyNameA, [:handle, :string, :ptr, :ptr], :bool
    attach_function :OpenSCManager, :OpenSCManagerA, [:ptr, :ptr, :dword], :handle
    attach_function :OpenService, :OpenServiceA, [:handle, :string, :dword], :handle
    attach_function :QueryServiceConfig, :QueryServiceConfigA, [:handle, :ptr, :dword, :ptr], :bool
    attach_function :QueryServiceConfig2, :QueryServiceConfig2A, [:handle, :dword, :ptr, :dword, :ptr], :bool
    attach_function :QueryServiceStatusEx, [:handle, :int, :ptr, :dword, :ptr], :bool
    attach_function :RegisterServiceCtrlHandlerEx, :RegisterServiceCtrlHandlerExA, [:str, :handler_ex, :ptr], :handle
    attach_function :SetServiceStatus, [:handle, :ptr], :bool
    attach_function :StartService, :StartServiceA, [:handle, :dword, :ptr], :bool
    attach_function :StartServiceCtrlDispatcher, :StartServiceCtrlDispatcherA, [:ptr], :bool, :blocking => true
  end
end
