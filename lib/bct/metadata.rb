require_relative './util'

# :nodoc:
module BrewCaskTools
  VERSION = Util.source_path('VERSION').read rescue '0.0.1'
  DESCRIPTION = 'A tiny tool that provides some missing functionality in Homebrew Cask.'.freeze
end
