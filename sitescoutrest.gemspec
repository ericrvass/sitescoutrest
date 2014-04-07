# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sitescoutrest/version'

Gem::Specification.new do |spec|
  spec.name          = "sitescoutrest"
  spec.version       = Sitescoutrest::VERSION
  spec.authors       = ["Eric Vass"]
  spec.email         = ["ericrvass@gmail.com"]
  spec.summary       = %q{A ruby client for the SiteScout REST api}
  #spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  #spec.files         = `git ls-files -z`.split("\x0")
  spec.files         = Dir["README.md","Gemfile","Rakefile", "lib/*", "lib/sitescoutrest/*", "lib/sitescoutrest/concerns/*"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
