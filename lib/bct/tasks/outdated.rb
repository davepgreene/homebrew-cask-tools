require 'thor'

module BrewCaskTools
  module Tasks
    # Upgrade tasks
    class Outdated < Thor
      desc 'outdated', 'list outdated casks'
      def outdated(*args)
        @caskroom = args.first
        @caskroom.outdated(&outdated_output)
        @caskroom.deprecated(&deprecated_output)
      end

      no_tasks do
        def outdated_output
          proc do |casks|
            say 'There are no outdated casks', :yellow if casks.empty?
            next if casks.empty?

            puts "Outdated packages\n------------------"
            headers = ['Package', 'Installed Version', 'New Version']
            output = casks.unshift(headers)
            print_table(output)
            puts "\n"
          end
        end

        def deprecated_output
          proc do |casks|
            next if casks.empty?

            puts "Deprecated packages\n------------------"
            casks.each do |cask|
              puts cask.name
            end
            puts "\n"
          end
        end
      end
    end
  end
end
