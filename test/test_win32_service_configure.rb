#######################################################################
# test_win32_service_configure.rb
#
# Test suite that validates the Service.configure method.
#######################################################################
require 'rubygems'
gem 'test-unit'

require 'win32/service'
require 'test/unit'

class TC_Service_Configure < Test::Unit::TestCase
   def self.startup
      @@service = "notepad_service"
      @@command = "C:\\windows\\system32\\notepad.exe"
            
      Win32::Service.new(
         :service_name     => @@service,
         :binary_path_name => @@command
      )
   end
   
   def config_info
      Win32::Service.config_info(@@service)
   end
   
   def full_info
      service = nil
      Win32::Service.services{ |s|
         if s.service_name == @@service
            service = s
            break
         end
      }
      service
   end
   
   def service_configure(opt)
      options = {:service_name => @@service}
      options = options.merge(opt)
      assert_nothing_raised{ Win32::Service.configure(options) }    
   end
   
   def setup
      @info = Win32::Service.config_info(@@service)
   end
   
   def test_service_configure_basic
      assert_respond_to(Win32::Service, :configure)
   end
   
   def test_service_type
      assert_equal('own process, interactive', config_info.service_type)
      service_configure(:service_type => Win32::Service::WIN32_SHARE_PROCESS)      
      assert_equal('share process', config_info.service_type)
   end
   
   def test_description
      assert_equal('', full_info.description)
      service_configure(:description => 'test service')     
      assert_equal('test service', full_info.description)
   end
   
   def test_start_type
      assert_equal('demand start', config_info.start_type)
      service_configure(:start_type => Win32::Service::DISABLED)
      assert_equal('disabled', config_info.start_type)      
   end
   
   def test_service_configure_expected_errors
      assert_raise(ArgumentError){ Win32::Service.configure }
      assert_raise(ArgumentError){ Win32::Service.configure('bogus') }
      assert_raise(ArgumentError){ Win32::Service.configure({}) }
      assert_raise(ArgumentError){ Win32::Service.configure(:binary_path_name => 'notepad.exe') }
   end
   
   def teardown
      @info = nil
   end
   
   def self.shutdown
      Win32::Service.delete(@@service) if Win32::Service.exists?(@@service)
      @@service = nil
      @@command = nil      
   end   
end