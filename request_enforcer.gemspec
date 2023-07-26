# frozen_string_literal: true

require_relative "lib/request_enforcer/version"

Gem::Specification.new do |spec|
  spec.name          = "request_enforcer"
  spec.version       = RequestEnforcer::VERSION

  spec.authors       = ["Artur Gin"]
  spec.email         = ["art.rad.gin@proton.me"]

  spec.summary       = "Enforce HTTP requests through your chosen for object"
  spec.description   = "Enforce HTTP requests through chosen for object"

  spec.homepage      = "https://github.com/ArturGin/request_enforcer"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "anyway_config", ">= 2.0.0"
  spec.add_dependency "sniffer", ">=0.5.0"

  spec.add_development_dependency "zeitwerk"
  spec.add_development_dependency 'httparty'
end
