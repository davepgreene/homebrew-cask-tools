require 'thor'

require_relative './caskroom'

module BrewCaskTools
  module Tasks
    # Cleanup task
    class Cleanup < Caskroom
      # @param optional casks [Array] array of cask names to cleanup
      def initialize(casks)
        super()

        @cleaned = []

        if casks.empty?
          progressbar.total = caskroom.casks.length
          progressbar.log "\nLooking for casks to cleanup..."

          @cleaned = compile
        else
          @cleaned = casks.map { |c| caskroom.get(c) }
          return say 'Invalid cask specified', :red if @cleaned.compact.empty?
        end
        clean
      end

      def compile
        cleaned = []
        caskroom.enumerate do |cask|
          increment(cask)

          cleaned << cask if cask.can_cleanup?
        end
        cleaned
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
