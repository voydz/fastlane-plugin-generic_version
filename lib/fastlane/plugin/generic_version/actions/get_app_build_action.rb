require 'fastlane/action'
require_relative '../helper/generic_version_helper'

module Fastlane
  module Actions
    class GetAppBuildAction < Action
      def self.run(params)
        platform = other_action.lane_context[SharedValues::PLATFORM_NAME]
        build = nil

        if platform == :android
          # android
          Helper::GenericVersionHelper.load_dependencies('fastlane-plugin-versioning_android')

          build = other_action.android_get_version_code
        else
          # ios or osx
          Helper::GenericVersionHelper.load_dependencies('fastlane-plugin-versioning')

          build = other_action.get_build_number_from_xcodeproj(
            target: params[:target],
            scheme: params[:scheme]
          )
        end

        build
      end

      def self.description
        "Manage your app build for Android and iOS"
      end

      def self.authors
        ["Felix Rudat"]
      end

      def self.return_value
        "The current app build"
      end

      def self.details
        "With this plugin you have a unified way to manage your cross platform app build."
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
