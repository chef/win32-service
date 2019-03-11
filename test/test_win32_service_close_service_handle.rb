########################################################################
# test_win32_service_close_service_handle.rb
#
# Test case for the close_service_handle method
########################################################################
require 'test-unit'
require 'win32/service'

class TC_Win32_Service_CloseServiceHandle < Test::Unit::TestCase
  def test_service_close_service_handle_returns_false_when_passed_nil
    assert_equal(false, Win32::Service.close_service_handle(nil))
  end

  def test_service_close_service_handle_returns_false_when_passed_0
    assert_equal(false, Win32::Service.close_service_handle(0))
  end

  def test_service_close_service_handle_returns_true_when_passed_an_open_handle
    handle_scm = Win32::Service.send(:OpenSCManager, nil, nil, Win32::Service::SC_MANAGER_ENUMERATE_SERVICE)
    assert_equal(true, Win32::Service.close_service_handle(handle_scm))
  end

  def test_service_close_service_handle_raises_argument_error_when_passed_a_string
    assert_raise(ArgumentError.new('You must pass a valid handle to ::close_service_handle')) do
      Win32::Service.close_service_handle("test")
    end
  end
end
