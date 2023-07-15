# frozen_string_literal: true

module RequestEnforcer
  class Error < StandardError; end
end

class UnEnforcedModuleError < RequestEnforcer::Error; end
