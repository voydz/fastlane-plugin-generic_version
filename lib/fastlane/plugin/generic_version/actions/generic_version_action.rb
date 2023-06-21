require 'fastlane/action'
require_relative '../helper/generic_version_helper'

module Fastlane
  module Actions
    class GenericVersionAction < Action
      def self.run(params)
        version = Helper::GenericVersionHelper.strip_tags(params[:version])
        build = Helper::GenericVersionHelper.strip_tags(params[:build])

        new_version = other_action.set_app_version(
          version: version,
          target: params[:target],
          scheme: params[:scheme]
        )

        new_build = other_action.set_app_build(
          build: build,
          target: params[:target],
          scheme: params[:scheme]
        )

        UI.important("New version is:")
        UI.message("  Version: #{new_version}")
        UI.message("  Build: #{new_build}")

        version
      end

      def self.description
        "Manage your app version for Android and iOS"
      end

      def self.authors
        ["Felix Rudat"]
      end

      def self.return_value
        "Whenever a specific version was set it will be returned, nil otherwise."
      end

      def self.details
        "With this plugin you have a unified way to manage your cross platform app version. Also it delivers some handy tools."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "GENERIC_VERSION_SET_APP_VERSION",
                                       description: "App version",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :build,
                                       env_name: "GENERIC_VERSION_SET_APP_BUILD",
                                       description: "App build",
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
