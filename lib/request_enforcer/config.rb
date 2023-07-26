# frozen_string_literal: true

require "anyway_config"
require "request_enforcer/root"

module RequestEnforcer
  # Config to startup Sniffer and validate params
  class Config < Anyway::Config
    config_name :request_enforcer

    attr_config warning_level: :error,
                enforced: {},
                root: RequestEnforcer::Root.root,
                silence_console_requests: true

    on_load :ensure_warning_level_is_correct,
            :set_sniffer

    def enforce(host, args)
      raise raise_validation_error("to_use key has to be included with a list of objects") if args[:to_use].nil?

      object_names = args[:to_use]
      object_names = [object_names] unless object_names.instance_of?(Array)

      enforced[host] = object_names
    end

    def ensure_warning_level_is_correct
      allowed = %i[error info]
      return if allowed.include?(warning_level)

      raise_validation_error("Warning level has to be one of #{allowed}")
    end

    def set_sniffer
      ::Sniffer.config do |c|
        c.enabled = true
        c.store = { capacity: 0, rotate: false } # so sniffer will not save logs and just wipe itself after each request
        c.middleware do |chain|
          chain.remove(::Sniffer::Middleware::Logger)
          chain.add(RequestEnforcer::Sniffer)
        end
      end
    end
  end
end
