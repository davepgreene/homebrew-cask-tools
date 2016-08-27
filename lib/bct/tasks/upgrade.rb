require 'thor'

require_relative './cleanup'

module BrewCaskTools
  module Tasks
    # Upgrade tasks
    class Upgrade < Thor
      desc 'upgrade CASK', 'Upgrade a specific cask.' \
      ' If a cask name is omitted, this task will update all outdated casks.'
      def upgrade(cask_name, *args)
        @caskroom = args.first
        cask = @caskroom.get(cask_name) unless cask_name.nil?

        if cask.nil? && !cask_name.nil?
          return say 'Invalid cask specified', :red
        end

        if cask_name.nil? # Upgrade everything
          upgrade_all
        else # Upgrade one cask
          upgrade_one(cask_name, cask)
        end
      end

      no_tasks do
        def upgrade_one(cask_name, cask)
          cask.upgrade
          invoke Tasks::Cleanup, :cleanup, [cask_name]
        end

        def upgrade_all
          to_upgrade = @caskroom.casklist.select(&:outdated?)

          if to_upgrade.empty?
            say 'There are no casks to be upgraded', :green
          else
            to_upgrade.each(&:upgrade)
          end

          invoke Tasks::Cleanup, :cleanup
        end
      end
    end
  end
end
