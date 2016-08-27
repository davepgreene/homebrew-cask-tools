require_relative './cask'
require 'thor'

module BrewCaskTools
  # Represents a list of Casks.
  class Caskroom < Thor::Shell::Basic
    attr_reader :casklist

    def initialize
      super
      @casks = `brew cask ls`.split("\n")
      @casklist = @casks.map { |cask| Cask.new(cask) }
    end

    def deprecated
      output = @casklist.select(&:deprecated?)
      yield output
    end

    def outdated
      output = @casklist.select(&:outdated?).map do |cask|
        [cask.name, cask.installed_version, cask.current_version]
      end
      yield output
    end

    def get(cask_name)
      @casklist.select { |e| e.name == cask_name }.first
    end
  end
end
