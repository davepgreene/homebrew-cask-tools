# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bct/metadata'

Gem::Specification.new do |spec|
  spec.name          = 'brew-cask-tools'
  spec.version       = BrewCaskTools::VERSION
  spec.authors       = ['Dave Greene']
  spec.email         = ['davepgreene@gmail.com']

  spec.summary       = 'Homebrew Cask update tools'
  spec.description   = BrewCaskTools::DESCRIPTION
  spec.homepage      = 'https://github.com/davepgreene/brew-cask-tools'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('{bin,lib}/**/*') + %w(LICENSE.txt README.md)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'awesome_print', '~> 1.7'

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'ruby-progressbar', '~> 1.8'
  spec.add_dependency 'git-version-bump', '~> 0.15'
end
