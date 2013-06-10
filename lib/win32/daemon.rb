require File.join(File.dirname(__FILE__), 'windows', 'helper')
require File.join(File.dirname(__FILE__), 'windows', 'constants')
require File.join(File.dirname(__FILE__), 'windows', 'structs')
require File.join(File.dirname(__FILE__), 'windows', 'functions')

module Win32
  class Daemon
    include Windows::Constants
    include Windows::Structs
    include Windows::Functions

    extend Windows::Structs
    extend Windows::Functions

    def initialize
    end
  end
end
