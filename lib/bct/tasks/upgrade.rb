require 'thor'

require_relative './caskroom'
require_relative './cleanup'

module BrewCaskTools
  module Tasks
    # Upgrade tasks
    class Upgrade < Caskroom
      def initialize(cask_name)
        super()

        if cask_name.nil?
          progressbar.total = caskroom.casks.length
          progressbar.log "\nLooking for outdated casks..."

          return upgrade_all # Clean all casks
        end

        cask = caskroom.get(cask_name)
        return say 'Invalid cask specified', :red if cask.nil?

        upgrade_one(cask)
      end

      def upgrade_all
        to_upgrade = []

        caskroom.enumerate do |cask|
          progressbar.title = "  #{cask.name.capitalize} "
          progressbar.increment

          next unless cask.outdated?

          to_upgrade << cask
          progressbar.log "#{cask.info.name}: " \
          "#{cask.installed_version} ==> #{cask.current_version}"
        end

        return say 'There are no casks to be upgraded', :green if to_upgrade.empty?

        to_upgrade.each(&:upgrade)

        Tasks::Cleanup.new(nil)
      end

      def upgrade_one(cask)
        cask.upgrade
        Tasks::Cleanup.new(cask.name)
      end
    end
  end
end
