require_relative './caskroom'

module BrewCaskTools
  module Tasks
    # Outdated cask tasks
    class Outdated < Caskroom
      def initialize
        super
        progressbar.total = caskroom.casks.length
        progressbar.log "\nLooking for outdated casks..."
        outdated, deprecated = compile

        outdated(outdated)
        deprecated(deprecated)
      end

      def compile
        outdated = []
        deprecated = []

        caskroom.enumerate do |cask|
          progressbar.title = "  #{cask.name.capitalize} "
          progressbar.increment

          outdated << cask if cask.outdated?
          deprecated << cask if cask.deprecated?
        end
        [outdated, deprecated]
      end

      def outdated(casks)
        return say "\nThere are no outdated casks", :yellow if casks.empty?
        handle(casks, 'outdated') do |outdated_casks|
          outdated_casks.map! do |c|
            [c.name, c.installed_version, c.current_version]
          end

          headers = ['Package', 'Installed Version', 'New Version']
          output = outdated_casks.unshift(headers)
          print_table(output)
        end
      end

      def deprecated(casks)
        return if casks.empty?
        handle(casks, 'deprecated') do |dep_casks|
          dep_casks.map! { |c| [c.name] }
          output = dep_casks.unshift(['Package'])
          print_table(output)
        end
      end

      def handle(casks, adverb)
        puts "#{adverb.capitalize} packages\n------------------"
        yield casks
        puts "\n"
      end
    end
  end
end
