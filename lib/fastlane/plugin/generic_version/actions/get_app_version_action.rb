require 'fastlane/action'
require_relative '../helper/generic_version_helper'

module Fastlane
  module Actions
    class GetAppVersionAction < Action
      def self.run(params)
        platform = other_action.lane_context[SharedValues::PLATFORM_NAME]
        version = nil

        if platform == :android
          # android
          Helper::GenericVersionHelper.load_dependencies('fastlane-plugin-versioning_android')

          version = other_action.android_get_version_name
        else
          # ios or osx
          Helper::GenericVersionHelper.load_dependencies('fastlane-plugin-versioning')

          version = other_action.get_version_number_from_xcodeproj(
            target: params[:target],
            scheme: params[:scheme]
          )
        end

        version
      end

      def self.description
        "Manage your app version for Android and iOS"
      end

      def self.authors
        ["Felix Rudat"]
      end

      def self.return_value
        "The current app version"
      end

      def self.details
        "With this plugin you have a unified way to manage your cross platform app version."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :target,
                                      env_name: "GENERIC_VERSION_APP_TARGET",
                                      optional: true,
                                      conflicting_options: [:scheme],
                                      description: "Specify a specific target if you have multiple per project, optional"),
          FastlaneCore::ConfigItem.new(key: :scheme,
                                       env_name: "GENERIC_VERSION_APP_SCHEME",
                                       optional: true,
                                       conflicting_options: [:target],
                                       description: "Specify a specific scheme if you have multiple per project, optional")
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
