require "win32/service"

describe Win32::Service do
  describe "::new" do
    let(:fake_pointer) { 12345 }
    let(:fake_bool) { 1 }

    before do
      # Swallow calls out to system
      allow_any_instance_of(Win32::Service).to receive(:CreateService).with(any_args).and_return(fake_pointer)
      allow_any_instance_of(Win32::Service).to receive(:ChangeServiceConfig2).with(any_args).and_return(fake_bool)
      allow_any_instance_of(Win32::Service).to receive(:configure_failure_actions).with(any_args)
    end

    it "does not raise an error" do
      expect { described_class.new(service_name: "my_new_service") }.not_to raise_error
    end
  end

  describe "::open_sc_manager" do
    context "when passed a block" do
      it "yields a pointer to a scm handle" do
        described_class.open_sc_manager do |scm_handle|
          expect(scm_handle).not_to be_nil
          expect(scm_handle).not_to eq(0)
          expect(scm_handle).to be_a(Integer)
        end
      end
    end
  end

  describe "::open_service" do
    context "when passed a block" do
      it "yields a pointer to a service handle" do
        described_class.open_sc_manager do |scm_handle|
          described_class.open_service(scm_handle, "Dhcp", described_class::SERVICE_QUERY_STATUS) do |service_handle|
            expect(service_handle).not_to be_nil
            expect(service_handle).not_to eq(0)
            expect(service_handle).to be_a(Integer)
          end
        end
      end
    end
  end

  describe "::status" do
    let(:dhcp_status) { described_class.status("Dhcp") }

    it "returns a StatusStruct" do
      expect(dhcp_status).to be_a(Win32::Service::StatusStruct)
    end

    %i{
      service_type
      current_state
      controls_accepted
      win32_exit_code
      service_specific_exit_code
      check_point
      wait_hint
      interactive
      pid
      service_flags
    }.each do |member|
      it "responds to #{member}" do
        expect(dhcp_status).to respond_to(member)
      end
    end

    context "dhcp status" do
      properties = {
        service_type: "share process",
        current_state: "running",
        controls_accepted: %w{shutdown stop},
        win32_exit_code: 0,
        service_specific_exit_code: 0,
        check_point: 0,
        wait_hint: 0,
        interactive: false,
        pid: 676,
        service_flags: 0,
      }

      properties.each do |property, value|
        unless property == :pid
          it "sets #{property} to #{value.inspect}" do
            expect(dhcp_status.send(property)).to eq(value)
          end
        end

        it "sets #{property} to a value of type #{value.class}" do
          expect(dhcp_status.send(property)).to be_a(value.class)
        end
      end
    end
  end
end
