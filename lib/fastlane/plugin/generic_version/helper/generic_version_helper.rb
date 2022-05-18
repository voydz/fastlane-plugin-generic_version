require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class GenericVersionHelper
      def self.strip_tags(version)
        # strip tags with regex
        version = version&.sub(/^\D+/, '')

        if version&.strip&.empty?
          # nil an empty string
          version = nil
        end

        version
      end

      def self.sanitize_version(version)
        if version&.strip&.empty?
          version = '0.0.0' # default version
        end

        version
      end

      def self.bump_version(current_version)
        # since auto incrementing the version is inconsistent between
        # increment_version_number() and android_set_version_name()
        # we implement our own version bumping here
        version_array = current_version.split(".").map(&:to_i)
        version_array[-1] = version_array[-1] + 1
        next_version_number = version_array.join(".")

        next_version_number
      end

      def self.load_dependencies
        # this is a hack to install missing plugins in the host project
        # better solution for @link https://github.com/fastlane/fastlane/issues/16650
        plugin_name = 'fastlane-plugin-versioning_android'

        unless Fastlane.plugin_manager.plugin_is_added_as_dependency?(plugin_name)
          Fastlane.plugin_manager.add_dependency(plugin_name)
          Fastlane.plugin_manager.load_plugins
        end
      end
    end
  end
end
