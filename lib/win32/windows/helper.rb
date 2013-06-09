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
