require 'win32/service'

describe Win32::Service do
  describe '::new' do
    let(:fake_pointer) { 12345 }
    let(:fake_bool) { 1 }

    before do
      # Swallow calls out to system
      allow_any_instance_of(Win32::Service).to receive(:CreateService).with(any_args).and_return(fake_pointer)
      allow_any_instance_of(Win32::Service).to receive(:ChangeServiceConfig2).with(any_args).and_return(fake_bool)
      allow_any_instance_of(Win32::Service).to receive(:configure_failure_actions).with(any_args)
    end

    it 'does not raise an error' do
      expect { described_class.new(service_name: 'my_new_service') }.not_to raise_error
    end
  end

  describe '::open_sc_manager' do
    context 'when passed a block' do
      it 'yields a pointer to a scm handle' do
        described_class.open_sc_manager do |scm_handle|
          expect(scm_handle).not_to be_nil
          expect(scm_handle).not_to eq(0)
          expect(scm_handle).to be_a(Integer)
        end
      end
    end
  end

  describe '::open_service' do
    context 'when passed a block' do
      it 'yields a pointer to a service handle' do
        described_class.open_sc_manager do |scm_handle|
          described_class.open_service(scm_handle, 'Dhcp', described_class::SERVICE_QUERY_STATUS) do |service_handle|
            expect(service_handle).not_to be_nil
            expect(service_handle).not_to eq(0)
            expect(service_handle).to be_a(Integer)
          end
        end
      end
    end
  end
end
