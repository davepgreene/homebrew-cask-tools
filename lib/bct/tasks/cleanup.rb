require 'thor'

module BrewCaskTools
  module Tasks
    # Upgrade tasks
    class Cleanup < Thor
      desc 'cleanup CASK', 'clean up old versions of a specific cask. If a ' \
      'cask name is omitted, this task will cleanup all outdated casks.'
      def cleanup(cask_name, *args)
        @caskroom = args.first
        cask = @caskroom.get(cask_name) unless cask_name.nil?

        if cask.nil? && !cask_name.nil?
          return say 'Invalid cask specified', :red
        end

        unless cask_name.nil?
          clean_single_cask(cask)
          return
        end

        clean_all_casks if cask_name.nil? # Cleanup everything
      end

      no_tasks do
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

        def clean_single_cask(cask)
          unless cask.can_cleanup?
            say "#{cask.name.capitalize} does not have any outdated " \
            'versions. No cleanup operations are necessary', :green
            return
          end

          cask.cleanup(&clean_block)
        end

        def clean_all_casks
          cleaned_casks = @caskroom.casklist.select(&:can_cleanup?)

          cleaned_casks.each do |c|
            c.cleanup(&clean_block)
          end

          say 'No cleanup operations are necessary', :green if cleaned_casks.empty?
        end
      end
    end
  end
end
