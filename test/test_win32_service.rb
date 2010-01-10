##########################################################################
# tc_service.rb
# 
# Test case for the Win32::Service class.
##########################################################################
require 'rubygems'
gem 'test-unit'

require 'win32/service'
require 'socket'
require 'test/unit'

class TC_Win32_Service < Test::Unit::TestCase
   def setup
      @display_name = "Task Scheduler"
      @service_name = "Schedule"      
      @service_stat = nil
      @services     = []
   end
   
   def wait_for_status(status)
      sleep 0.1 while Win32::Service.status(@service_name).current_state != status
   end

   def test_version
      assert_equal('0.7.0', Win32::Service::VERSION)
   end
   
   def test_services_basic
      assert_respond_to(Win32::Service, :services)
      assert_nothing_raised{ Win32::Service.services }
      assert_nothing_raised{ Win32::Service.services(nil) }
      assert_nothing_raised{ Win32::Service.services(nil, 'network') }
   end
      
   def test_services_non_block_form
      assert_nothing_raised{ @services = Win32::Service.services }
      assert_kind_of(Array, @services)
      assert_kind_of(Struct::ServiceInfo, @services[0])
   end
   
   def test_services_block_form
      assert_nothing_raised{ Win32::Service.services{ |s| @services << s } }
      assert_kind_of(Array, @services)
      assert_kind_of(Struct::ServiceInfo, @services[0])      
   end
      
   def test_services_expected_errors
      assert_raise(TypeError){ Win32::Service.services(1) }
      assert_raise(TypeError){ Win32::Service.services(nil, 1) }
      assert_raise(ArgumentError){ Win32::Service.services(nil, 'network', 1) }
      assert_raise(Win32::Service::Error){ Win32::Service.services('bogus') }
   end   
   
   def test_delete
      assert_respond_to(Win32::Service, :delete)
   end
   
   def test_delete_expected_errors
      assert_raise(ArgumentError){ Win32::Service.delete }
      assert_raise(Win32::Service::Error){ Win32::Service.delete('bogus') }
      assert_raise(Win32::Service::Error){ Win32::Service.delete('bogus', 'bogus') }
      assert_raise(ArgumentError){ Win32::Service.delete('x', 'y', 'z') }
   end
   
   def test_service_pause_and_resume
      assert_respond_to(Win32::Service, :pause)
      assert_respond_to(Win32::Service, :resume)
      assert_nothing_raised{ Win32::Service.pause(@service_name) }
      assert_nothing_raised{ wait_for_status('paused') }
      assert_nothing_raised{ Win32::Service.pause(@service_name) }  
      assert_nothing_raised{ Win32::Service.resume(@service_name) }
      assert_nothing_raised{ wait_for_status('running') }
   end
   
   def test_pause_expected_errors
      assert_raise(ArgumentError){ Win32::Service.pause }
      assert_raise(Win32::Service::Error){ Win32::Service.pause('bogus') }
      assert_raise(Win32::Service::Error){ Win32::Service.pause('bogus', 'bogus') }
      assert_raise(ArgumentError){ Win32::Service.pause('x', 'y', 'z') }
   end
   
   def test_resume_expected_errors
      assert_raise(ArgumentError){ Win32::Service.resume }
      assert_raise(Win32::Service::Error){ Win32::Service.resume('bogus') }
      assert_raise(Win32::Service::Error){ Win32::Service.resume('bogus', 'bogus') }
      assert_raise(ArgumentError){ Win32::Service.resume('bogus', 'bogus', 'a') }
   end          
   
   def test_service_stop_and_start
      assert_respond_to(Win32::Service, :stop)
      assert_respond_to(Win32::Service, :start)
      assert_nothing_raised{ Win32::Service.stop(@service_name) }
      assert_nothing_raised{ wait_for_status('stopped') }
      assert_raise(Win32::Service::Error){ Win32::Service.stop(@service_name) }  
      assert_nothing_raised{ Win32::Service.start(@service_name) }
      assert_nothing_raised{ wait_for_status('running') }
   end
   
   def test_stop_expected_errors
      assert_raise(ArgumentError){ Win32::Service.stop }
      assert_raise(Win32::Service::Error){ Win32::Service.stop('bogus') }
      assert_raise(Win32::Service::Error){ Win32::Service.stop('bogus', 'bogus') }
      assert_raise(ArgumentError){ Win32::Service.stop('x', 'y', 'z') }
   end
   
   def test_start_expected_errors
      assert_raise(ArgumentError){ Win32::Service.start }
      assert_raise(Win32::Service::Error){ Win32::Service.start(@service_name) } # Started
      assert_raise(Win32::Service::Error){ Win32::Service.start('bogus') }
      assert_raise(Win32::Service::Error){ Win32::Service.start('bogus', 'bogus') }
      assert_raise(Win32::Service::Error){ Win32::Service.start('bogus', 'bogus', 'a') }
      assert_raise(Win32::Service::Error){ Win32::Service.start('a', 'b', 'c', 'd') }
   end   
   
   def test_service_stop_expected_errors
      assert_raise(ArgumentError){ Win32::Service.stop }
      assert_raise(Win32::Service::Error){ Win32::Service.stop('bogus') }
      assert_raise(Win32::Service::Error){ Win32::Service.stop('bogus', 'bogus') }
      assert_raise(ArgumentError){ Win32::Service.stop('a', 'b', 'c') }
   end

   def test_service_status_basic
      assert_respond_to(Win32::Service, :status)
      assert_nothing_raised{ Win32::Service.status(@service_name) }
      assert_kind_of(Struct::ServiceStatus, Win32::Service.status(@service_name))
   end

   def test_service_get_service_name_basic
      assert_respond_to(Win32::Service, :get_service_name)
      assert_nothing_raised{ Win32::Service.get_service_name(@display_name) }
      assert_kind_of(String, Win32::Service.get_service_name(@display_name))
   end

   def test_service_getservicename_alias_basic
      assert_respond_to(Win32::Service, :getservicename)
      assert_nothing_raised{ Win32::Service.getservicename(@display_name) }
      assert_kind_of(String, Win32::Service.getservicename(@display_name))
   end

   def test_service_get_service_name
      assert_equal(@service_name, Win32::Service.get_service_name(@display_name))
      assert_equal(@service_name, Win32::Service.getservicename(@display_name))
   end

   def test_service_get_service_name_expected_errors
      assert_raise(ArgumentError){ Win32::Service.get_service_name }
      assert_raise(Win32::Service::Error){ Win32::Service.get_service_name('bogus') }
      assert_raise(Win32::Service::Error){ Win32::Service.get_service_name('foo','bogus') }
      assert_raise(ArgumentError){ Win32::Service.get_service_name('x', 'y', 'z') }
   end

   def test_service_get_display_name_basic
      assert_respond_to(Win32::Service, :get_display_name)
      assert_nothing_raised{ Win32::Service.get_display_name(@service_name) }
      assert_kind_of(String, Win32::Service.get_display_name(@service_name))
   end

   def test_service_getdisplayname_alias_basic
      assert_respond_to(Win32::Service, :getdisplayname)
      assert_nothing_raised{ Win32::Service.getdisplayname(@service_name) }
      assert_kind_of(String, Win32::Service.getdisplayname(@service_name))
   end

   def test_service_get_display_name
      assert_equal(@display_name, Win32::Service.get_display_name(@service_name))
      assert_equal(@display_name, Win32::Service.getdisplayname(@service_name))
   end

   def test_service_get_display_name_expected_errors
      assert_raise(ArgumentError){ Win32::Service.get_display_name }
      assert_raise(Win32::Service::Error){ Win32::Service.get_display_name('bogus') }
      assert_raise(Win32::Service::Error){ Win32::Service.get_display_name('foo','bogus') }
      assert_raise(ArgumentError){ Win32::Service.get_display_name('x', 'y', 'z') }
   end

   def test_service_exists
      assert_respond_to(Win32::Service, :exists?)
      assert_nothing_raised{ Win32::Service.exists?('W32Time') }
      assert_equal(true, Win32::Service.exists?('W32Time'))
      assert_equal(false, Win32::Service.exists?('foobar'))
   end

   def test_service_exists_expected_errors
      assert_raises(ArgumentError){ Win32::Service.exists? }
      assert_raises(Win32::Service::Error){Win32::Service.exists?('foo', 'bogushost') }
      assert_raises(ArgumentError){ Win32::Service.exists?('foo', 'bar', 'baz') }
   end
      
   def test_scm_security_constants
      assert_not_nil(Win32::Service::MANAGER_ALL_ACCESS)
      assert_not_nil(Win32::Service::MANAGER_CREATE_SERVICE)
      assert_not_nil(Win32::Service::MANAGER_CONNECT)
      assert_not_nil(Win32::Service::MANAGER_ENUMERATE_SERVICE)
      assert_not_nil(Win32::Service::MANAGER_LOCK)
      assert_not_nil(Win32::Service::MANAGER_QUERY_LOCK_STATUS)
   end

   def test_service_specific_constants
      assert_not_nil(Win32::Service::ALL_ACCESS)
      assert_not_nil(Win32::Service::CHANGE_CONFIG)
      assert_not_nil(Win32::Service::ENUMERATE_DEPENDENTS)
      assert_not_nil(Win32::Service::INTERROGATE)
      assert_not_nil(Win32::Service::PAUSE_CONTINUE)
      assert_not_nil(Win32::Service::QUERY_CONFIG)
      assert_not_nil(Win32::Service::QUERY_STATUS)
      assert_not_nil(Win32::Service::STOP)
      assert_not_nil(Win32::Service::START)
      assert_not_nil(Win32::Service::USER_DEFINED_CONTROL)
   end

   def test_service_type_constants
      assert_not_nil(Win32::Service::FILE_SYSTEM_DRIVER)
      assert_not_nil(Win32::Service::KERNEL_DRIVER)
      assert_not_nil(Win32::Service::WIN32_OWN_PROCESS)
      assert_not_nil(Win32::Service::WIN32_SHARE_PROCESS)
      assert_not_nil(Win32::Service::INTERACTIVE_PROCESS)
   end

   def test_service_start_option_constants
      assert_not_nil(Win32::Service::AUTO_START)
      assert_not_nil(Win32::Service::BOOT_START)
      assert_not_nil(Win32::Service::DEMAND_START)
      assert_not_nil(Win32::Service::DISABLED)
      assert_not_nil(Win32::Service::SYSTEM_START)
   end

   def test_service_error_control_constants
      assert_not_nil(Win32::Service::ERROR_IGNORE)
      assert_not_nil(Win32::Service::ERROR_NORMAL)
      assert_not_nil(Win32::Service::ERROR_SEVERE)
      assert_not_nil(Win32::Service::ERROR_CRITICAL)
   end

   def test_service_state_constants
      assert_not_nil(Win32::Service::CONTINUE_PENDING)
      assert_not_nil(Win32::Service::PAUSE_PENDING)
      assert_not_nil(Win32::Service::PAUSED)
      assert_not_nil(Win32::Service::RUNNING)
      assert_not_nil(Win32::Service::START_PENDING)
      assert_not_nil(Win32::Service::STOP_PENDING)
      assert_not_nil(Win32::Service::STOPPED)      
   end
   
   def teardown
      @display_name = nil
      @service_name = nil
      @service_stat = nil
      @services     = nil
   end
end
