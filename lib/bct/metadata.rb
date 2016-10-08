# :nodoc:
module BrewCaskTools
  VERSION = `git describe --abbrev=0 --tags`.delete('v')
  DESCRIPTION = 'A tiny tool that provides some missing functionality in Homebrew Cask.'.freeze
end
