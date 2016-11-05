require 'versionomy'

module BrewCaskTools
  module Casks
    # Parent class for different types of Versions
    class Version
      DIR_BLACKLIST = ['.', '..', '.metadata'].freeze

      def initialize(dir)
        @dir = dir
      end

      def versions
        @versions ||= latest? ? ['latest'] : all_versions.sort
      end

      def latest?
        all_versions.select { |version| version.to_s == 'latest' }.length.positive?
      end

      def rm_old
        old.each { |version| rm(version) }
      end

      def old
        _, *previous = versions.reverse
        previous
      end

      def self.parse_version(version)
        Versionomy.parse(version)
      rescue Versionomy::Errors::ParseError
        version
      end

      private

      def rm(version)
        version_dir = File.join(@dir, version.to_s)
        ::FileUtils.rm_rf(version_dir, secure: true, verbose: true)
      end

      def all_versions
        Dir.entries(@dir)
           .reject { |dir| DIR_BLACKLIST.include?(dir) }
           .map do |version|
             if File.directory?(File.join(@dir, version))
               Version.parse_version(version)
             end
           end.compact
      end
    end
  end
end
