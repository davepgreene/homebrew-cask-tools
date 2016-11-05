require_relative './caskroom'

module BrewCaskTools
  module Tasks
    # Outdated cask task
    class Outdated < Caskroom
      def initialize
        super
        progressbar.total = caskroom.casks.length
        progressbar.log "\nLooking for outdated casks..."
        @outdated, @deprecated = compile

        outdated
        deprecated
      end

      def compile
        outdated = []
        deprecated = []
        caskroom.enumerate do |cask|
          increment(cask)

          outdated << cask if cask.outdated?
          deprecated << cask if cask.deprecated?
        end
        [outdated, deprecated]
      end

      def outdated
        return say "\nThere are no outdated casks", :yellow if @outdated.empty?

        @outdated.map! do |cask|
          [cask.name, cask.current, cask.candidate]
        end

        handle(@outdated, 'outdated') do |outdated|
          format(['Package', 'Installed Version', 'New Version'], outdated)
        end
      end

      def deprecated
        return if @deprecated.empty?

        @deprecated.map! { |cask| [cask.name] }

        handle(@deprecated, 'deprecated') do |deprecated|
          format(['Package'], deprecated)
        end
      end
    end
  end
end
