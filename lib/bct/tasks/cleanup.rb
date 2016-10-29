require 'thor'

require_relative './caskroom'

module BrewCaskTools
  module Tasks
    # Cleanup tasks
    class Cleanup < Caskroom
      def initialize(casks)
        super()

        @cleaned = []

        if casks.empty?
          progressbar.total = caskroom.casks.length
          progressbar.log "\nLooking for casks to cleanup..."

          compile
        else
          @cleaned = casks.map { |c| caskroom.get(c) }
          return say 'Invalid cask specified', :red if @cleaned.compact.empty?
        end
        clean
      end

      def compile
        caskroom.enumerate do |cask|
          increment(cask)

          @cleaned << cask if cask.can_cleanup?
        end
      end

      def clean
        return say "\nNo cleanup operations are necessary", :green if @cleaned.empty?

        @cleaned.each do |cask|
          cask.cleanup(&clean_block)
        end
      end

      def clean_block
        proc do |cask, versions|
          name = cask.name
          say "Cleaning up #{name}", :yellow
          if cask.deprecated? &&
             no?("#{name} has been deprecated. Ok to remove all versions?", :red)

            say 'No action taken.', :red
            next
          end
          say "Removed #{versions.length} old version(s)", :yellow
        end
      end
    end
  end
end
