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

    context "when http request is made in development env" do
      context "when it was called from an enforced module" do
        let(:enforced_object) { :ModuleTest }
        let(:host) { "httpbingo.org" }

        it { expect(Sniffer).to be_enabled }

        it "doesnt not raise an error" do
          expect { ModuleTest.test }.not_to raise_error(UnEnforcedModuleError, "TODO add proper errors")
          expect(Sniffer.data).to be_empty
        end
      end

      context "when it was called from instance of a class" do
        let(:enforced_object) { :ClassInstanceTest }
        let(:host) { "httpbingo.org" }

        it { expect(Sniffer).to be_enabled }

        it "doesnt not raise an error" do
          expect { ClassInstanceTest.new.test }.not_to raise_error(UnEnforcedModuleError, "TODO add proper errors")
          expect(Sniffer.data).to be_empty
        end
      end

      context "when it was called not from enforced object" do
        let(:enforced_object) { :GamersRiseUp }
        let(:host) { "httpbingo.org" }

        let(:error_message) do
          "Error: httpbingo.org/json did not use enforced modules [:GamersRiseUp]! TODO PROPER ERROR"
        end

        it { expect(Sniffer).to be_enabled }

        it "raises an error" do
          expect { ModuleRaiseError.test }.to raise_error(UnEnforcedModuleError, error_message)
          expect(Sniffer.data).to be_empty
        end
      end

      context "when request enforcer is disabled" do
        let(:enforced_object) { :GamersRiseUp }
        let(:host) { "httpbingo.org" }

        it "allows any request to be made" do
        end
      end
    end
  end

  describe "when RequestEnforced is not configured" do
    it { expect(Sniffer).not_to be_enabled }

    it "doesnt procces any requests" do
      expect { ModuleTest.test }.not_to raise_error(UnEnforcedModuleError, "TODO add proper errors")
      expect(Sniffer.data).to be_empty
    end
  end
end
