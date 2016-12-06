module Fastlane
  module Helper
    class ForceSignHelper
      # class methods that you define here become available in your action
      # as `Helper::ForceSignHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the force_sign plugin helper!")
      end
    end
  end
end
