# frozen_string_literal: true

require "request_enforcer/trace_back_checker"

module RequestEnforcer
  # Sniffer middleware to catch requests being made
  class Sniffer
    def request(data_item)
      TraceBackChecker.check(traces: caller_locations(0), request: data_item.request)
      yield
    end

    def response(data_item); end
  end
end
