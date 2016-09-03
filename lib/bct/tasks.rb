require 'thor'

require_relative './caskroom'
require_relative './tasks/upgrade'
require_relative './tasks/outdated'
require_relative './tasks/cleanup'
require_relative './metadata'

module BrewCaskTools
  module Tasks
    # Entrypoint for CLI
    class CLI < Thor
      def initialize(args, opts, config)
        super
        return if %w(help version).include?(config[:current_command].name)
        `brew update` # Update Caskroom tap so the latest formulae are pulled down
      end

      def self.exit_on_failure?
        true
      end

      desc 'version', 'display brew-cask-tools version'
      def version
        say BrewCaskTools::VERSION, :green
      end

      desc 'outdated', 'list outdated casks'
      def outdated
        Tasks::Outdated.new
      end

      desc 'upgrade CASK', 'Upgrade a specific cask.' \
      ' If a cask name is omitted, this task will update all outdated casks.'
      def upgrade(cask_name = nil)
        Tasks::Upgrade.new(cask_name)
      end

      desc 'cleanup CASK', 'clean up old versions of a specific cask. If a ' \
      'cask name is omitted, this task will cleanup all outdated casks.'
      def cleanup(cask_name = nil)
        Tasks::Cleanup.new(cask_name)
      end
    end
  end
end
