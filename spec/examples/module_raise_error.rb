# frozen_string_literal: true

module ModuleRaiseError
  def self.test
    HTTParty.get("http://httpbingo.org/json")
  end
end
