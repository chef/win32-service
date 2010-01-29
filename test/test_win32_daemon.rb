#########################################################################
# test_win32_daemon.rb
#
# Test suite for the Win32::Daemon class. You should run this test via
# the 'rake test' or 'rake test_daemon' tasks.
#
# These tests are rather limited, since the acid test is to install
# your daemon as a service and see how it behaves.
#########################################################################
require 'rubygems'
gem 'test-unit'

require 'win32/daemon'
require 'test/unit'
include Win32

class TC_Daemon < Test::Unit::TestCase
  def setup
    @daemon = Daemon.new
  end
   
  def test_version
    assert_equal('0.7.1', Daemon::VERSION)
  end
   
  def test_constructor
    assert_respond_to(Daemon, :new)
    assert_nothing_raised{ Daemon.new }
    assert_raises(ArgumentError){ Daemon.new(1) } # No arguments by default
  end
   
  def test_mainloop
    assert_respond_to(@daemon, :mainloop)
  end
   
  def test_state
    assert_respond_to(@daemon, :state)
  end
   
  def test_running
    assert_respond_to(@daemon, :running?)
  end
   
  def test_constants
    assert_not_nil(Daemon::CONTINUE_PENDING)
    assert_not_nil(Daemon::PAUSE_PENDING)
    assert_not_nil(Daemon::PAUSED)
    assert_not_nil(Daemon::RUNNING)
    assert_not_nil(Daemon::START_PENDING)
    assert_not_nil(Daemon::STOP_PENDING)
    assert_not_nil(Daemon::STOPPED)
    assert_not_nil(Daemon::IDLE) 
  end
   
  def teardown
    @daemon = nil
  end
end
