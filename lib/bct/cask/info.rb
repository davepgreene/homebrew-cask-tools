require 'pry'

module BrewCaskTools
  # Class to keep brittle parsing of `brew cask info #{cask}` localized.
  class Info
    def initialize(arr)
      @info = arr.nil? ? [] : arr
    end

    def short_name
      @info[0]
    end

    def url
      @info[1]
    end

    def path
      @info[2]
    end

    def cask_url
      @info[3]
    end

    def name
      @info[5]
    end

    def app_name
      @info[7]
    end
  end
end
