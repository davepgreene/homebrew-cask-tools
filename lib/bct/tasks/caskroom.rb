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
    end
  end
end
