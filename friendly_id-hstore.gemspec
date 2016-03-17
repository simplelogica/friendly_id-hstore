# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'friendly_id/hstore/version'

Gem::Specification.new do |spec|
  spec.name          = "friendly_id-hstore"
  spec.version       = FriendlyId::Hstore::VERSION
  spec.authors       = ["Óscar de Arriba"]
  spec.email         = ["oscar.dearriba@the-cocktail.com"]

  spec.summary       = "Adapter to use friendly_id with hstore_translate for localized slugs"
  spec.description   = "Adapter to use friendly_id with hstore_translate for localized slugs"
  spec.homepage      = "https://github.com/simplelogica/friendly_id-hstore/"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "friendly_id"
  spec.add_dependency "hstore_translate", "~> 1.0.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
