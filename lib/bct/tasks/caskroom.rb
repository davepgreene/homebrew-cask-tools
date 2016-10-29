require 'thor'
require 'ruby-progressbar'

require_relative '../caskroom'

module BrewCaskTools
  module Tasks
    # Base class for Tasks that interact with the Caskroom
    class Caskroom < Thor::Shell::Basic
      def caskroom
        @caskroom ||= BrewCaskTools::Caskroom.new
      end

      def progressbar
        @progressbar ||= ProgressBar.create(title: '  Progress ')
      end

      def handle(casks, adverb)
        puts "#{adverb.capitalize} packages\n------------------"
        yield casks
        puts "\n"
      end

      def increment(cask)
        progressbar.title = "  #{cask.name.capitalize} "
        progressbar.increment
      end

      def format(headers, output)
        print_table(output.unshift(headers))
      end
    end
  end
end
