require_relative './version'

module BrewCaskTools
  module Casks
    # Operations on a collection of Cask versions
    class Versions
      attr_reader :local, :meta

      def initialize(dir, candidate)
        @candidate = candidate
        @local = Version.new(dir)
        @meta = Version.new(File.join(dir, '.metadata'))
      end

      def installed
        @local.versions
      end

      def metadata
        @meta.versions
      end

      def candidate
        Version.parse_version(@candidate)
      end

      def current
        installed.last
      end

      def latest?
        current.to_s == 'latest'
      end

      def old_installed
        @local.old
      end

      def old_metadata
        @meta.old
      end

      def rm_old
        @local.rm_old
        @meta.rm_old
      end
    end
  end
end
