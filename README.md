# BrewCaskTools

A tiny tool that provides some missing functionality in [Homebrew Cask](https://caskroom.github.io).

## Installation
Install [Homebrew](http://brew.sh).

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Install [Homebrew Cask](https://caskroom.github.io).

    $ brew tap caskroom/cask

Install brew-cask-tools.

    $ gem install brew-cask-tools

## Usage

```
Commands:
  bct cleanup CASK    # clean up old versions of a specific cask. If a cask name is omitted, this task will cleanup all outdate...
  bct help [COMMAND]  # Describe available commands or one specific command
  bct outdated        # list outdated casks
  bct upgrade CASK    # Upgrade a specific cask. If a cask name is omitted, this task will update all outdated casks.
  bct version         # display brew-cask-tools version
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davepgreene/brew-cask-tools. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
