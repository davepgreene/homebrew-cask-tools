require 'thor'

require_relative './caskroom'

module BrewCaskTools
  module Tasks
    # Cleanup tasks
    class Cleanup < Caskroom
      def initialize(cask_name)
        super()

        if cask_name.nil?
          progressbar.total = caskroom.casks.length
          progressbar.log "\nLooking for casks to cleanup..."

          return clean_all # Clean all casks
        end

        cask = caskroom.get(cask_name)
        return say 'Invalid cask specified', :red if cask.nil?

        clean_one(cask)
      end

      def clean_one(cask)
        return say "#{cask.name.capitalize} does not have any outdated " \
          'versions. No cleanup operations are necessary', :green unless cask.can_cleanup?

        cask.cleanup(&clean_block)
      end

      def clean_all
        cleaned_casks = []

        caskroom.enumerate do |cask|
          progressbar.title = "  #{cask.name.capitalize} "
          progressbar.increment

          cleaned_casks << cask if cask.can_cleanup?
        end

        return say "\nNo cleanup operations are necessary", :green if cleaned_casks.empty?

        cleaned_casks.each { |c| c.cleanup(&clean_block) }
      end

      def clean_block
        proc do |c, versions|
          say "Cleaning up #{c.name}", :yellow
          dep_q = "#{c.name} has been deprecated. Ok to remove all versions?"
          if c.deprecated? && no?(dep_q, :red)
            say 'No action taken.', :red
            next
          end
          say "Removed #{versions.length} old version(s)", :yellow
        end
      end
    end
  end
end
