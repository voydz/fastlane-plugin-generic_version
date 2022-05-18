require 'fastlane/action'
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
          Helper::GenericVersionHelper.load_dependencies

          version = other_action.android_get_version_name
        else 
          # ios or osx
          version = other_action.get_version_number
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
        []
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
