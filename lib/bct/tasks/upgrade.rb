require 'thor'

require_relative './caskroom'
require_relative './cleanup'

module BrewCaskTools
  module Tasks
    # Upgrade task
    class Upgrade < Caskroom
      # @param optional casks [Array] array of cask names to upgrade
      def initialize(casks)
        super()

        @upgrade = []

        if casks.empty?
          progressbar.total = caskroom.casks.length
          progressbar.log "\nLooking for outdated casks..."

          @upgrade = compile
        else
          @upgrade = casks.map { |c| caskroom.get(c) }
          return say 'Invalid cask(s) specified', :red if @upgrade.compact.empty?
        end

        upgrade
      end

      # Get list of casks to upgrade
      # @return [Array] an array of casks to upgrade
      def compile
        upgrade = []
        caskroom.enumerate do |cask|
          increment(cask)

          next unless cask.outdated?

          upgrade << cask
          progressbar.log "#{cask.info.name}: " \
          "#{cask.current} ==> #{cask.candidate}"
        end
        upgrade
      end

      # Upgrade casks
      def upgrade
        return say 'There are no casks to be upgraded', :green if @upgrade.empty?
        @upgrade.each(&:upgrade)

        # Cleanup casks that we upgraded
        Tasks::Cleanup.new(@upgrade.map(&:name))
      end
    end
  end
end
