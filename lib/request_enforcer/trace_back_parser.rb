# frozen_string_literal: true

module RequestEnforcer
  # methods for trace parsing
  module TraceBackParser
    def parse_traces
      @traces.select { |i| i.include?(RequestEnforcer.config.root) }
    end

    def request_from_console?
      [
        "bin/rails:4:in `<main>'",
        "bin/console:15:in `<main>'",
        "-e:1:in `<main>'"
      ].include?(@traces.detect { |i| i.include?("main") })
    end

    def parse_traces_into_modules
      @app_specific_traces.map do |trace|
        called_files = trace.split("/") # split a trace string by directory
                            .detect { |i| i.include?("rb") } # detect rb file

        next if called_files.nil? # move to the next trace if the file doesnt have an rb ending

        called_files.split(".")[0] # gets rid off called method and rb ending
                    .split("_").map(&:capitalize).join # camelize the file name
      end.compact
    end
  end
end
