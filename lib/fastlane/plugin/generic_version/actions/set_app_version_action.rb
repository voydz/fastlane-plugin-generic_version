require 'fastlane/action'
require_relative '../helper/generic_version_helper'

module Fastlane
  module Actions
    class SetAppVersionAction < Action
      def self.run(params)
        platform = other_action.lane_context[SharedValues::PLATFORM_NAME]
        version = params[:version]

        unless version
          UI.important("No specific version was given. The current version will be incremented.")

          # increment current version number
          current_version = Helper::GenericVersionHelper.sanitize_version(other_action.get_app_version(
                                                                            target: params[:target],
                                                                            scheme: params[:scheme]
                                                                          ))
          version = Helper::GenericVersionHelper.bump_version(current_version)
        end

        if platform == :android
          # android
          Helper::GenericVersionHelper.load_dependencies('fastlane-plugin-versioning_android')

          version = other_action.android_set_version_name(
            version_name: version
          )
        else
          # ios or osx
          Helper::GenericVersionHelper.load_dependencies('fastlane-plugin-versioning')

          version = other_action.increment_version_number_in_xcodeproj(
            version_number: version,
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
        "The new app version"
      end

      def self.details
        "With this plugin you have a unified way to manage your cross platform app version."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "GENERIC_VERSION_SET_APP_VERSION",
                                       description: "Version",
                                       optional: true,
                                       type: String),
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
