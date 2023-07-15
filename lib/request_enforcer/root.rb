# frozen_string_literal: true

module RequestEnforcer
  # Find the root of an application
  class Root
    def self.root
      if defined? Rails
        Rails.configuration.root
      else
        Dir.pwd.split("/").last
      end
    end
  end
end
