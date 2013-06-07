require 'ffi'

module Windows
  module Functions
    extend FFI::Library

    typedef :ulong, :dword
    typedef :uintptr_t, :handle
    typedef :pointer, :ptr

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
    attach_function :GetServiceDisplayName, :GetServiceDisplayNameA, [:handle, :string, :ptr, :ptr], :bool
    attach_function :GetServiceKeyName, :GetServiceKeyNameA, [:handle, :string, :ptr, :ptr], :bool
    attach_function :OpenSCManager, :OpenSCManagerA, [:ptr, :ptr, :dword], :handle
    attach_function :OpenService, :OpenServiceA, [:handle, :string, :dword], :handle
    attach_function :QueryServiceConfig, :QueryServiceConfigA, [:handle, :ptr, :dword, :ptr], :bool
    attach_function :QueryServiceStatusEx, [:handle, :int, :ptr, :dword, :pointer], :bool
    attach_function :StartService, :StartServiceA, [:handle, :dword, :ptr], :bool
  end
end
