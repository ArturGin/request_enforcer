# frozen_string_literal: true

class ClassInstanceTest
  def initalize; end

  def test
    HTTParty.get("http://httpbingo.org/json")
  end
end
