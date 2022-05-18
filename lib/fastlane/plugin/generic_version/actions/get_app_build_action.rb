require 'fastlane/action'
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
          Helper::GenericVersionHelper.load_dependencies

          build = other_action.android_get_version_code
        else 
          # ios or osx
          build = other_action.get_build_number
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
        []
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
