# frozen_string_literal: true

RSpec.describe RequestEnforcer do
  it "has a version number" do
    expect(RequestEnforcer::VERSION).not_to be nil
  end

  describe "when RequestEnforcer is configured" do
    before do
      described_class.config do |c|
        c.enforce host, to_use: enforced_object
        c.warning_level = :error
      end
    end

    after(:all) do
      Sniffer.disable! # is this correct to put here?
    end

    let(:raised_error_message) {
      format(error_message, host: host, enforced_modules:[enforced_object], query: '/json')
    }

    context "when it was called from an enforced module" do
      let(:enforced_object) { :ModuleTest }
      let(:host) { "httpbingo.org" }

      it { expect(Sniffer).to be_enabled }

      it "doesnt not raise an error" do
        expect { ModuleTest.test }.not_to raise_error(UnEnforcedModuleError)
        expect(Sniffer.data).to be_empty
      end
    end

    context "when it was called from instance of a class" do
      let(:enforced_object) { :ClassInstanceTest }
      let(:host) { "httpbingo.org" }

      it { expect(Sniffer).to be_enabled }

      it "doesnt not raise an error" do
        expect { ClassInstanceTest.new.test }.not_to raise_error(UnEnforcedModuleError)
        expect(Sniffer.data).to be_empty
      end
    end

    context "when it was called not from enforced object" do
      let(:enforced_object) { :GamersRiseUp }
      let(:host) { "httpbingo.org" }

      it { expect(Sniffer).to be_enabled }

      it "raises an error" do
        expect { ModuleRaiseError.test }.to raise_error(UnEnforcedModuleError, raised_error_message)
        expect(Sniffer.data).to be_empty
      end
    end

    context 'and was disabled!' do
      let(:enforced_object) { :GamersRiseUp }
      let(:host) { "httpbingo.org" }

      it 'allow any requests' do
        described_class.disable!
        expect { ModuleRaiseError.test }.not_to raise_error(UnEnforcedModuleError)
      end
    end
  end

  describe "when RequestEnforced is not configured" do
    it { expect(Sniffer).not_to be_enabled }

    it "doesnt procces any requests" do
      expect { ModuleTest.test }.not_to raise_error(UnEnforcedModuleError)
      expect(Sniffer.data).to be_empty
    end
  end

  describe "when RequestEnforced poorly" do
    context "when warning level is wrong" do
      it do 
        expect do 
          described_class.config { |c|
            c.warning_level = :sbalto
          }.to raise_error(Anyway::Config::ValidationError)
        end
      end
    end
  end
end
