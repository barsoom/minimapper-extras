# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minimapper/extras/version'

Gem::Specification.new do |spec|
  spec.name          = "minimapper-extras"
  spec.version       = Minimapper::Extras::VERSION
  spec.authors       = ["Joakim Kolsjö", "Henrik Nyh"]
  spec.email         = ["joakim.kolsjo@gmail.com", "henrik@barsoom.se"]
  spec.summary       = %q{Extras for Minimapper.}
  spec.homepage      = ""
  spec.license       = "MIT"

  # We bundle this gem within the app, having this leads
  # to git errors when deploying.
  if File.exist?(".git")
    spec.files         = `git ls-files`.split($/)
  end

  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "minimapper", ">= 0.8"
  spec.add_dependency "attr_extras"
  spec.add_development_dependency "bundler", ">= 2.2.10"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  # We can't assume that everything in this gem needs activemodel, but we
  # need it to run all of the specs.
  spec.add_development_dependency "activemodel"
end
