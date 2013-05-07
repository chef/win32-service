require 'ffi'

module Windows
  module Functions
    extend FFI::Library
    ffi_lib :kernel32
  end
end
