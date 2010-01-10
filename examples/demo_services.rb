#######################################################################
# demo_services.rb
#
# Test script for general futzing that shows off the basic
# capabilities of this library. Modify as you see fit.
#######################################################################
require 'win32/service'
include Win32

puts "VERSION: " + Service::VERSION

p Service.exists?("ClipSrv")
p Service.exists?("foo")

status = Service.status("ClipSrv")
p status

info = Service.config_info("ClipSrv")
p info

Service.services{ |struct|
   p struct
}
