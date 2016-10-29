require 'fileutils'
require 'thor'
require 'open3'

require_relative './cask/info'
require_relative './cask/versions'

# Location of homebrew cask's caskroom
CASKROOM = '/usr/local/Caskroom'.freeze

module BrewCaskTools
  # Cask control class. Implements operations on a single cask.
  class Cask < Thor::Shell::Basic
    attr_reader :name, :dir, :info

    def initialize(name)
      super()

      @name = name

      if deprecated?
        info = []
        @name = name.delete(' (!)')
      else
        info = `brew cask info #{name}`.split("\n")
      end

      @info = Casks::Info.new(info)
      @dir = File.join(CASKROOM, @name)
      @versions = Casks::Versions.new(@dir, @info.short_name.sub("#{@name}: ", ''))
    end

    def current
      @versions.current
    end

    def candidate
      @versions.candidate
    end

    def versions
      @versions.installed
    end

    def old
      @versions.old_installed
    end

    def metadata
      @versions.metadata
    end

    def latest?
      @versions.latest?
    end

    def deprecated?
      @deprecated ||= @name.include?('(!)')
    end

    def can_cleanup?
      versions.length > 1 || metadata.length > 1
    end

    def outdated?
      return false if latest?
      candidate > current
    end

    def exec
      Open3.popen2e("brew cask install #{@name} --force") do |_stdin, stdout_err, _wait_thr|
        line = ''
        while line
          line = stdout_err.gets
          puts line
        end
      end
    end

    def upgrade
      return say "#{@name} uses the `latest` convention. " \
      'Homebrew cask does not upgrade casks marked as ' \
      '`latest`. Use another method of determining if ' \
      'this application has an upgrade', :green if latest?

      return say "You have the most recent version of #{@name}. " \
      'It cannot be upgraded', :green unless outdated?

      say "Installing #{@name} (#{candidate})", :cyan
      exec
      say "Upgraded #{@name} to version #{candidate}", :green
    end

    def cleanup
      return unless can_cleanup?

      if deprecated?
        yield self, versions
        # Delete the whole cask
        ::FileUtils.rm_rf(@dir, secure: true, verbose: true)
        return
      end

      yield self, old

      @versions.rm_old
    end
  end
end
