require 'ffi'

module Windows
  module Functions
    extend FFI::Library

    typedef :ulong, :dword
    typedef :uintptr_t, :handle
    typedef :pointer, :ptr

    ffi_lib :advapi32

    attach_function :CloseServiceHandle, [:handle], :bool
    attach_function :GetServiceDisplayName, :GetServiceDisplayNameA, [:handle, :string, :ptr, :ptr], :bool
    attach_function :OpenSCManager, :OpenSCManagerA, [:ptr, :ptr, :dword], :handle
    attach_function :OpenService, :OpenServiceA, [:handle, :string, :dword], :handle
  end
end
