require_relative './cask'

module BrewCaskTools
  # Represents a list of Casks.
  class Caskroom
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
      casklist { |cask| yield Cask.new(cask) }
    end

    def get(cask_name)
      cask = casks.select { |name| name == cask_name }
      cask.empty? ? nil : Cask.new(cask.first)
    end
  end
end
