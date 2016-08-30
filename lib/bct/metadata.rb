require_relative './util'

# :nodoc:
module BrewCaskTools
  VERSION = begin
              Util.source_path('VERSION').read
            rescue
              '0.0.1'
            end
  DESCRIPTION = 'A tiny tool that provides some missing functionality in Homebrew Cask.'.freeze
end
