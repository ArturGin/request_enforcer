# frozen_string_literal: true

require_relative "request_enforcer/version"
require_relative "request_enforcer/sniffer"
require "httparty"
require "sniffer"
require "request_enforcer/config"

# RequestEnforcer allows you to specify which HTTP host can use which object
module RequestEnforcer
  class << self
    def config
      @config ||= Config.new
      yield @config if block_given?
      @config
    end

    def disable!
      @config = nil
      @disabled = true
      @enabled = false
      true
    end

    def enabled?
      !@config.nil?
    end
  end
end
