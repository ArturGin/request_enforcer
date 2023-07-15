# frozen_string_literal: true

require "request_enforcer/errors"

module RequestEnforcer
  # Checks traces for modules if a request was made and stops them if they are not enforced
  class TraceBackChecker
    def initialize(traces:, request:)
      @traces = traces.map(&:to_s)
      @request = request
      parse_traces
    end

    def self.check(traces:, request:)
      new(traces: traces, request: request).check
    end

    def check # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      return if RequestEnforcer.config.enforced[@request.host].nil?

      enforced_objects = RequestEnforcer.config.enforced[@request.host]
      return if enforced_objects.map do |mdl|
                  @called_modules.include?(mdl.to_s)
                end.uniq.include?(true)

      # TODO: add colour?
      if RequestEnforcer.config.warning_level == :error
        raise UnEnforcedModuleError,
              "Error: #{@request.host}#{@request.query} did not use enforced modules #{enforced_objects}! TODO PROPER ERROR"
      else
        puts "Warning: #{@request.host}#{@request.query} did not use enforced modules #{enforced_objects}!"
        # TODO: add links to github repo and some more info
      end
    end

    private

    def parse_traces
      app_specific_traces = @traces.select { |i| i.include?(RequestEnforcer.config.root) }
      @called_modules = app_specific_traces.map do |trace|
        trace.split("/") # split a trace string by directory
             .detect { |i| i.include?("rb") } # detect rb file
             .split(".")[0] # gets rid off called method and rb ending
             .split("_").map(&:capitalize).join # camelize the file name
      end
    end
  end
end
