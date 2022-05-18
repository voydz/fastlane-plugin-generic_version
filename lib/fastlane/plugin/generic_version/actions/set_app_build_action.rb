require 'fastlane/action'
require 'fastlane/action'
require_relative '../helper/generic_version_helper'

module Fastlane
  module Actions
    class SetAppBuildAction < Action
      def self.run(params)
        platform = other_action.lane_context[SharedValues::PLATFORM_NAME]
        build = params[:build]

        unless build
          # just a notification
          UI.important("No specific build was given. The current build will be incremented.")
        end

        if platform == :android
          # android
          Helper::GenericVersionHelper.load_dependencies

          build = other_action.android_set_version_code(
            version_code: build,
          )
        else 
          # ios or osx
          build = other_action.increment_build_number(
            build_number: build,
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
        "The new app build"
      end

      def self.details
        "With this plugin you have a unified way to manage your cross platform app build."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :build,
                                       env_name: "APP_BUILD",
                                       description: "Build",
                                       optional: true,
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
