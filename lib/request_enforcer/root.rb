# frozen_string_literal: true

module RequestEnforcer
  # Find the root of an application
  class Root
    def self.root
      Dir.pwd
    end
  end
end
