# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fossicker/version"

Gem::Specification.new do |spec|
  spec.name          = "fossicker"
  spec.version       = Fossicker::VERSION
  spec.authors       = ["John Carney"]
  spec.email         = ["john@carney.id.au"]

  spec.summary       = %q{A fetch-like version of Ruby's dig}
  spec.description   = %q{A fetch-like version of Ruby's dig.}
  spec.homepage      = "http://www.github.com/johncarney/fossicker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake",    "~> 10.0"
  spec.add_development_dependency "rspec",   "~> 3.0"
end
