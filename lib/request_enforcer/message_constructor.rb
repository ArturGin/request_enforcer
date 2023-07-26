# frozen_string_literal: true

module RequestEnforcer
  # Holds and constucts messages
  module MessageConstructor
    def warning_message
      "Warning: %{host}%{query} did not use enforced modules %{enforced_modules}! \n
      If you are suprised to see this warning go to https://github.com/ArturGin/request_enforcer for more info \n
      To disable this warning run RequestEnforcer.disable!"
    end

    def error_message
      "Error: %{host}%{query} did not use enforced modules %{enforced_modules}! \n
      If you are suprised to see this error go to https://github.com/ArturGin/request_enforcer for more info \n
      To disable this error run RequestEnforcer.disable! or change RequestEnforcer.config"
    end
  end
end
