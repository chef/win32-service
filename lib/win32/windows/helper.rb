require 'ffi'

class FFI::Pointer
  def read_array_of_null_separated_strings
    elements = []
    loc = self

    while element = loc.read_string
      break if element.nil? || element == ""
      elements << element
      loc += element.size + 1
    end

    elements
  end
end

module FFI
  extend FFI::Library

  ffi_lib :kernel32

  attach_function :FormatMessage, :FormatMessageA,
    [:ulong, :pointer, :ulong, :ulong, :pointer, :ulong, :pointer], :ulong

  def win_error
    flags = 0x00001000 | 0x00000200
    buf = FFI::MemoryPointer.new(:char, 1024)

    FormatMessage(flags, nil, FFI.errno , 0x0409, buf, 1024, nil)

    buf.read_string.strip
  end

  module_function :win_error
end
