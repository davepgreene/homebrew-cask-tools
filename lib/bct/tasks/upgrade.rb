require 'thor'

require_relative './caskroom'
require_relative './cleanup'

module BrewCaskTools
  module Tasks
    # Upgrade tasks
    class Upgrade < Caskroom
      def initialize(casks)
        super()

        @upgrade = []

        if casks.empty?
          progressbar.total = caskroom.casks.length
          progressbar.log "\nLooking for outdated casks..."

          compile
        else
          @upgrade = casks.map { |c| caskroom.get(c) }
          return say 'Invalid cask(s) specified', :red if @upgrade.compact.empty?
        end

        upgrade
      end

      def compile
        caskroom.enumerate do |cask|
          increment(cask)

          next unless cask.outdated?

          @upgrade << cask
          progressbar.log "#{cask.info.name}: " \
          "#{cask.installed_version} ==> #{cask.current_version}"
        end
      end

      def upgrade
        return say 'There are no casks to be upgraded', :green if @upgrade.empty?
        @upgrade.each(&:upgrade)

        # Cleanup casks that we upgraded
        Tasks::Cleanup.new(@upgrade.map(&:name))
      end
    end
  end
end
