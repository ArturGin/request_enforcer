# frozen_string_literal: true

require "bundler/setup"
require "request_enforcer"
require "zeitwerk"
require 'request_enforcer/message_constructor'

loader = Zeitwerk::Loader.new
loader.push_dir(File.expand_path("examples", __dir__))
loader.setup

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include RequestEnforcer::MessageConstructor
end
RSpec::Expectations.configuration.on_potential_false_positives = :nothing
