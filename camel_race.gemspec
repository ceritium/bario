# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "camel_race/version"

Gem::Specification.new do |spec|
  spec.name          = "camel_race"
  spec.version       = CamelRace::VERSION
  spec.authors       = ["Jose Galisteo"]
  spec.email         = ["ceritium@gmail.com"]

  spec.summary       = "Nested progress bars backed by redis"
  spec.homepage      = "https://github.com/ceritium/camel_race"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["camelrace-demo", "camelrace-web"]
  spec.require_paths = ["lib"]

  spec.add_dependency "ohm", "~> 3.0"
  spec.add_dependency "sinatra"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "guard-rubocop", "~> 1.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.51"
  spec.add_development_dependency "rubocop-rspec", "~> 1.20"
end
