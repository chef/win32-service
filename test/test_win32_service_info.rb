########################################################################
# test_win32_service_info.rb
#
# Test case for the Struct::ServiceInfo structure.
########################################################################
require "test-unit"
require "win32/service"

class TC_Win32_ServiceInfo_Struct < Test::Unit::TestCase
  def self.startup
    @@services = Win32::Service.services
  end

  def setup
    @service_name = "Dhcp"
    @service_info = @@services.find { |s| s.service_name == @service_name }

    @error_controls = [
      "critical",
      "ignore",
      "normal",
      "severe",
      nil,
    ]

    @start_types = [
      "auto start",
      "boot start",
      "demand start",
      "disabled",
      "system start",
       nil,
    ]

    @types = [
      "file system driver",
      "kernel driver",
      "own process",
      "share process",
      "recognizer token",
      "driver",
      "win32",
      "all",
      "own process, interactive",
      "share process, interactive",
      nil,
    ]

    @states = [
      "continue pending",
      "pause pending",
      "paused",
      "running",
      "start pending",
      "stop pending",
      "stopped",
       nil,
    ]

    @controls = [
      "netbind change",
      "param change",
      "pause continue",
      "pre-shutdown",
      "shutdown",
      "stop",
      "hardware profile change",
      "power event",
      "session change",
      "interrogate",
    ]
  end

  test "service_name basic functionality" do
    assert_respond_to(@service_info, :service_name)
    assert_kind_of(String, @service_info.service_name)
  end

  test "display_name basic functionality" do
    assert_respond_to(@service_info, :display_name)
    assert_kind_of(String, @service_info.display_name)
  end

  test "service_type basic functionality" do
    assert_respond_to(@service_info, :service_type)
    assert(@types.include?(@service_info.service_type))
  end

  test "current_state basic functionality" do
    assert_respond_to(@service_info, :current_state)
    assert(@states.include?(@service_info.current_state))
  end

  test "controls_accepted basic functionality" do
    assert_respond_to(@service_info, :controls_accepted)
    assert_kind_of(Array, @service_info.controls_accepted)
  end

  test "controls_accepted returns expected values" do
    assert_false(@service_info.controls_accepted.empty?)
    @service_info.controls_accepted.each { |c| assert_true(@controls.include?(c)) }
  end

  test "win32_exit_code basic functionality" do
    assert_respond_to(@service_info, :win32_exit_code)
    assert_kind_of(Integer, @service_info.win32_exit_code)
  end

  test "service_specific_exit_code basic functionality" do
    assert_respond_to(@service_info, :service_specific_exit_code)
    assert_kind_of(Integer, @service_info.service_specific_exit_code)
  end

  test "check_point basic functionality" do
    assert_respond_to(@service_info, :check_point)
    assert_kind_of(Integer, @service_info.check_point)
  end

  test "wait_hint basic functionality" do
    assert_respond_to(@service_info, :wait_hint)
    assert_kind_of(Integer, @service_info.wait_hint)
  end

  test "binary_path_name basic functionality" do
    assert_respond_to(@service_info, :binary_path_name)
    assert_kind_of(String, @service_info.binary_path_name)
  end

  test "start_type basic functionality" do
    assert_respond_to(@service_info, :start_type)
    assert(@start_types.include?(@service_info.start_type))
  end

  test "error_control basic functionality" do
    assert_respond_to(@service_info, :error_control)
    assert(@error_controls.include?(@service_info.error_control))
  end

  test "load_order_group basic functionality" do
    assert_respond_to(@service_info, :load_order_group)
    assert_kind_of(String, @service_info.load_order_group)
  end

  test "tag_id basic functionality" do
    assert_respond_to(@service_info, :tag_id)
    assert_kind_of(Integer, @service_info.tag_id)
  end

  test "start_name basic functionality" do
    assert_respond_to(@service_info, :start_name)
    assert_kind_of(String, @service_info.start_name)
  end

  test "dependencies basic functionality" do
    assert_respond_to(@service_info, :dependencies)
    assert_kind_of(Array, @service_info.dependencies)
  end

  test "description basic functionality" do
    assert_respond_to(@service_info, :description)
    assert_kind_of(String, @service_info.description)
  end

  test "interactive basic functionality" do
    assert_respond_to(@service_info, :interactive)
    assert_boolean(@service_info.interactive)
  end

  test "service_flags basic functionality" do
    assert_respond_to(@service_info, :service_flags)
    assert([0, 1].include?(@service_info.service_flags))
  end

  test "delayed_start basic functionality" do
    assert_respond_to(@service_info, :delayed_start)
    assert([0, 1].include?(@service_info.delayed_start))
  end

  def teardown
    @types    = nil
    @states   = nil
    @controls = nil
    @service_name = nil
  end

  def self.shutdown
    @@services = nil
  end
end
