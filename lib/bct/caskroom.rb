require 'thor'
require 'pry'

require_relative './cask'

module BrewCaskTools
  # Represents a list of Casks.
  class Caskroom < Thor::Shell::Basic
    def initialize
      super
    end

    def casks
      @casks ||= `brew cask ls`.split("\n")
    end

    def casklist
      @casklist ||= casks.map { |cask| yield cask }
    end

    def enumerate
      casklist do |c|
        yield Cask.new(c)
      end
    end

    def get(cask_name)
      c = casks.select { |e| e == cask_name }.first
      Cask.new(c)
    end
  end
end
