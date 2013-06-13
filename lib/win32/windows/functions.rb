require 'ffi'

module Windows
  module Functions
    extend FFI::Library

    typedef :ulong, :dword
    typedef :uintptr_t, :handle
    typedef :pointer, :ptr

    ffi_lib :kernel32

    callback :service_ctrl_func, [:dword], :void

    attach_function :CreateEvent, [:pointer, :bool, :bool, :string], :handle
    attach_function :EnterCriticalSection, [:pointer], :void
    attach_function :InitializeCriticalSection, [:pointer], :void
    attach_function :LeaveCriticalSection, [:pointer], :void
    attach_function :RegisterServiceCtrlHandler, [:string, :service_ctrl_func], :handle
    attach_function :SetEvent, [:handle], :bool
    attach_function :SetServiceStatus, [:handle, :pointer], :bool
    attach_function :WaitForSingleObject, [:handle, :dword], :dword

    ffi_lib :advapi32

    attach_function :CloseServiceHandle, [:handle], :bool

    attach_function :ChangeServiceConfig, :ChangeServiceConfigA,
      [:handle, :dword, :dword, :dword, :string, :string, :ptr, :string, :string, :string],
      :bool

    attach_function :ChangeServiceConfig2, :ChangeServiceConfig2A, [:handle, :dword, :ptr], :bool

    attach_function :CreateService, :CreateServiceA,
      [:handle, :string, :string, :dword, :dword, :dword, :dword,
       :string, :string, :ptr, :string, :string, :string],
       :handle

    attach_function :ControlService, [:handle, :dword, :ptr], :bool
    attach_function :DeleteService, [:handle], :bool

    attach_function :EnumServicesStatusEx, :EnumServicesStatusExA,
      [:handle, :int, :dword, :dword, :pointer, :dword, :ptr, :ptr, :ptr, :string],
      :bool

    attach_function :GetServiceDisplayName, :GetServiceDisplayNameA, [:handle, :string, :ptr, :ptr], :bool
    attach_function :GetServiceKeyName, :GetServiceKeyNameA, [:handle, :string, :ptr, :ptr], :bool
    attach_function :OpenSCManager, :OpenSCManagerA, [:ptr, :ptr, :dword], :handle
    attach_function :OpenService, :OpenServiceA, [:handle, :string, :dword], :handle
    attach_function :QueryServiceConfig, :QueryServiceConfigA, [:handle, :ptr, :dword, :ptr], :bool
    attach_function :QueryServiceConfig2, :QueryServiceConfig2A, [:handle, :dword, :ptr, :dword, :ptr], :bool
    attach_function :QueryServiceStatusEx, [:handle, :int, :ptr, :dword, :pointer], :bool
    attach_function :StartService, :StartServiceA, [:handle, :dword, :ptr], :bool
  end
end
