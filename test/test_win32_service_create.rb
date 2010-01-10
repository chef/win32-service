########################################################################
# tc_service_create.rb
#
# Test case for the Service.create method. This test case will create
# a dummy (notepad) service. It won't actually run of course.
########################################################################
require 'rubygems'
gem 'test-unit'

require 'win32/service'
require 'test/unit'

class TC_Service_Create < Test::Unit::TestCase
   def self.startup
      @@service1 = "notepad_service1"
      @@service2 = "notepad_service2"
      @@command  = "C:\\windows\\system32\\notepad.exe"
      
      Win32::Service.new(
         :service_name     => @@service1,
         :binary_path_name => @@command
      )
      
      Win32::Service.new(
         :service_name     => @@service2,
         :display_name     => 'Notepad Test',
         :desired_access   => Win32::Service::ALL_ACCESS,
         :service_type     => Win32::Service::WIN32_OWN_PROCESS,
         :start_type       => Win32::Service::DISABLED,
         :error_control    => Win32::Service::ERROR_IGNORE,
         :binary_path_name => @@command,
         :load_order_group => 'Network',
         :dependencies     => 'W32Time',
         :description      => 'Test service. Please delete me'
      )
   end
   
   def setup
      @info1 = Win32::Service.config_info(@@service1)
      @info2 = Win32::Service.config_info(@@service2)
   end

   def test_new_basic
      assert_respond_to(Win32::Service, :new)
   end
   
   def test_create_alias
      assert_respond_to(Win32::Service, :create)
      assert_equal(Win32::Service.method(:create), Win32::Service.method(:new))
   end
   
   # Sanity test to ensure the services were actually created. If this test
   # fails, the results for other tests are meaningless.
   #
   def test_service_created
      assert_true(Win32::Service.exists?(@@service1))
      assert_true(Win32::Service.exists?(@@service2))
   end
   
   def test_service_configuration_info
      assert_equal('own process, interactive', @info1.service_type)
      assert_equal('demand start', @info1.start_type)
      assert_equal('normal', @info1.error_control)
      assert_equal(@@command, @info1.binary_path_name)
      assert_equal('', @info1.load_order_group)
      assert_equal(0, @info1.tag_id)
      assert_equal([], @info1.dependencies)
      assert_equal('LocalSystem', @info1.service_start_name)
      assert_equal('notepad_service1', @info1.display_name)
   end
  
   def test_service_configuration_info_multiple_options  
      assert_equal('own process', @info2.service_type)
      assert_equal('disabled', @info2.start_type)
      assert_equal('ignore', @info2.error_control)
      assert_equal(@@command, @info2.binary_path_name)
      assert_equal('Network', @info2.load_order_group)
      assert_equal(0, @info2.tag_id)
      assert_equal(['W32Time'], @info2.dependencies)
      assert_equal('LocalSystem', @info2.service_start_name)
      assert_equal('Notepad Test', @info2.display_name)      
   end

   def test_create_expected_errors
      assert_raise(ArgumentError){ Win32::Service.new }
      assert_raise(ArgumentError){ Win32::Service.new(:binary_path_name => 'test.exe') }
      assert_raise(ArgumentError){ Win32::Service.new(:bogus => 'test.exe') }
   end

   def teardown
      @info1 = nil
      @info2 = nil
   end
   
   def self.shutdown
      Win32::Service.delete(@@service1) if Win32::Service.exists?(@@service1)
      Win32::Service.delete(@@service2) if Win32::Service.exists?(@@service2)

      @@service1 = nil
      @@service2 = nil
      @@command  = nil
   end
end
