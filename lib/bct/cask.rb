require 'fileutils'
require 'thor'
require 'open3'
require 'pry'

require_relative './cask/info'

CASKROOM = '/usr/local/Caskroom'.freeze
DIR_BLACKLIST = ['.', '..', '.metadata'].freeze

module BrewCaskTools
  # Cask control class. Implements operations on a single cask.
  class Cask < Thor::Shell::Basic
    attr_reader :name, :dir

    def initialize(name)
      super()

      @name = name

      if deprecated?
        info = []
        @name = name.delete(' (!)')
      else
        info = `brew cask info #{name}`.split("\n")
      end

      @info = Info.new(info)
      @deprecated = deprecated?
      @dir = File.join(CASKROOM, @name)
    end

    def filter_info
      @info.info.select! { |i| !i.end_with?('(does not exist)') }
    end

    def current_version
      @info.short_name.sub("#{@name}: ", '')
    end

    def installed_version
      local_versions.last
    end

    def local_versions
      Dir.entries(@dir)
         .reject { |i| DIR_BLACKLIST.include?(i) }
         .sort
    end

    def local_metadata_versions
      Dir.entries(File.join(@dir, '.metadata'))
         .reject { |i| DIR_BLACKLIST.include?(i) }
         .sort
    end

    def deprecated?
      @deprecated ||= @name.include?('(!)')
    end

    def can_cleanup?
      return true if @deprecated
      (local_versions.length > 1 || local_metadata_versions.length > 1)
    end

    def outdated?
      current_version != installed_version
    end

    def upgrade
      return say "You have the most recent version of #{@name}. " \
      'It cannot be upgraded', :green unless outdated?

      say "Installing #{@name} (#{current_version})", :cyan
      cmd = "brew cask install #{@name} --force"
      Open3.popen2e(cmd) do |_stdin, stdout_err, _wait_thr|
        while line = stdout_err.gets
          puts line
        end
      end
      say "Upgraded #{@name} to version #{current_version}", :green
    end

    def old_versions
      old(local_versions)
    end

    def old_metadata
      old(local_metadata_versions)
    end

    def old(arr)
      _, *previous = arr.reverse
      previous
    end

    def cleanup
      return unless can_cleanup?
      if @deprecated == true
        yield self, local_versions
        # Delete the whole cask
        rm(@dir)
        return
      end

      yield self, old_versions
      rm_old(old_versions, method(:rm_version))
      rm_old(old_metadata, method(:rm_metadata))
    end

    def rm_old(versions, method)
      versions.each do |version|
        method.call(version)
      end
    end

    def rm_version(version)
      rm(File.join(@dir, version))
    end

    def rm_metadata(version)
      rm(File.join(@dir, '.metadata', version))
    end

    def rm(dir)
      ::FileUtils.rm_rf(dir, secure: true, verbose: true)
    end
  end
end
