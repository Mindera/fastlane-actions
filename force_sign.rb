module Fastlane
  module Actions
    class ForceSignAction < Action

      def self.run(options)
        require 'xcodeproj'

        project = Xcodeproj::Project.open(options[:xcodeproj_path])

        target = project.targets.select{ |target| target.name == options[:scheme] }.first
        project_atributes = project.root_object.attributes
        build_settings = target.build_configuration_list[options[:build_configuration]].build_settings

        UI.message "Updating Xcode project's ProvisioningStyle to '#{options[:provisioning_style]}' 🛠".green
        project_atributes['TargetAttributes'][target.uuid]['ProvisioningStyle'] = options[:provisioning_style]

        UI.message "Updating Xcode project's CODE_SIGN_IDENTITY to \"#{options[:code_sign_identity]}\" 🔑".green
        build_settings["CODE_SIGN_IDENTITY"] = options[:code_sign_identity]
        build_settings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"] = options[:code_sign_identity]

        UI.message "Updating Xcode project's PROVISIONING_PROFILE_SPECIFIER to \"#{options[:profile_name]}\" 🔧".green
        build_settings["PROVISIONING_PROFILE_SPECIFIER"] = options[:profile_name]

        # This item is set as optional in the configuration values
        # Since Xcode 8, this is no longer needed, you use PROVISIONING_PROFILE_SPECIFIER
        if options[:profile_uuid]
            UI.message "Updating Xcode project's PROVISIONING_PROFILE to \"#{options[:profile_uuid]}\" 🔧".green
            build_settings["PROVISIONING_PROFILE"] = options[:profile_uuid]
        end

        UI.message "Updating Xcode project's DEVELOPMENT_TEAM to \"#{options[:development_team]}\" 👯".green
        build_settings["DEVELOPMENT_TEAM"] = options[:development_team]

        project.save
      end

      def self.available_options
        [
            FastlaneCore::ConfigItem.new(key: :xcodeproj_path,
                                         env_name: "PROJECT_PATH",
                                         description: "The Project Path"),
            FastlaneCore::ConfigItem.new(key: :scheme,
                                         env_name: "SCHEME",
                                         description: "Scheme"),
            FastlaneCore::ConfigItem.new(key: :build_configuration,
                                         env_name: "BUILD_CONFIGURATION",
                                         description: "Build configuration (Debug, Release, ...)"),
            FastlaneCore::ConfigItem.new(key: :provisioning_style,
                                         env_name: "PROVISIONING_STYLE",
                                         description: "Provisioning style (Automatic, Manual)",
                                         default_value: "Manual"),
            FastlaneCore::ConfigItem.new(key: :code_sign_identity,
                                         env_name: "CODE_SIGN_IDENTITY",
                                         description: "Code signing identity type (iPhone Development, iPhone Distribution)",
                                         default_value: "iPhone Distribution"),
            FastlaneCore::ConfigItem.new(key: :profile_name,
                                         env_name: "PROVISIONING_PROFILE_SPECIFIER",
                                         description: "Provisioning profile name to use for code signing",
                                         default_value: "\"$(PROFILE_NAME)\""),
            FastlaneCore::ConfigItem.new(key: :profile_uuid,
                                         env_name: "PROVISIONING_PROFILE",
                                         description: "Provisioning profile UUID to use for code signing",
                                         optional: true),
            FastlaneCore::ConfigItem.new(key: :development_team,
                                         env_name: "TEAM_ID",
                                         description: "Development team identifier",
                                         default_value: "\"$(PROFILE_UUID)\"")
        ]
      end

      def self.description
        "Setup Xcode project's code signing settings by force 💪"
      end

      def self.is_supported?(platform)
        platform == :ios
      end

      def self.authors
        ["portellaa", "p4checo", "mindera.com"]
      end

    end
  end
end