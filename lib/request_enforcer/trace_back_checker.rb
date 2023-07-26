# frozen_string_literal: true

require "request_enforcer/errors"
require "request_enforcer/trace_back_parser"
require "request_enforcer/message_constructor"

module RequestEnforcer
  # Checks traces for modules if a request was made and stops them if they are not enforced
  class TraceBackChecker
    include RequestEnforcer::TraceBackParser
    include RequestEnforcer::MessageConstructor

    def initialize(traces:, request:)
      @traces = traces.map(&:to_s)
      @request = request
      @request_from_console = request_from_console?
      @app_specific_traces = parse_traces
      @called_modules = parse_traces_into_modules
    end

    def self.check(traces:, request:)
      obj = new(traces: traces, request: request)
      return if obj.skip_checks?

      obj.check
    end

    def check # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      enforced_objects = RequestEnforcer.config.enforced[@request.host]

      return if enforced_objects.map do |obj|
                  @called_modules.include?(obj.to_s)
                end.uniq.include?(true)

      {
        error: lambda do
          raise UnEnforcedModuleError, format(error_message,
                                              host: @request.host,
                                              query: @request.query,
                                              enforced_modules: enforced_objects)
        end,

        warning: lambda do
          puts format(warning_message,
                      host: @request.host,
                      query: @request.query,
                      enforced_modules: enforced_objects)
        end
      }[RequestEnforcer.config.warning_level].call
    end

    def skip_checks?
      [
        RequestEnforcer.config.enforced[@request.host].nil?,
        @request_from_console && RequestEnforcer.config.silence_console_requests
      ].include?(true)
    end
  end
end
