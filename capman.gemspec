# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capman/version'

Gem::Specification.new do |gem|
  gem.name          = "capman"
  gem.version       = Capman::VERSION
  gem.authors       = ["John Griffin"]
  gem.email         = ["johnog@gmail.com"]
  gem.description   = "Capman"
  gem.summary       = "Capman"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
