# frozen_string_literal: true

module ModuleTest
  def self.test
    HTTParty.get("http://httpbingo.org/json")
  end
end
