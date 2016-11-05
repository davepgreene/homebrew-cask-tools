require_relative './cask'

module BrewCaskTools
  # Represents a list of Casks.
  class Caskroom
    def initialize
      super
    end

    # An array of installed casks
    # @return [Array]
    def casks
      @casks ||= `brew cask ls`.split("\n")
    end

    # @param [Proc]
    def enumerate
      casks.map do |cask|
        yield Cask.new(cask)
      end
    end

    # @param cask_name [String]
    # @return [BrewCaskTools::Cask]
    def get(cask_name)
      cask = casks.select { |name| name == cask_name }
      cask.empty? ? nil : Cask.new(cask.first)
    end
  end
end
