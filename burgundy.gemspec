require "./lib/burgundy/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 2.1.0"
  spec.name          = "burgundy"
  spec.version       = Burgundy::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]
  spec.description   = "A simple wrapper for objects (think of Burgundy as a decorator/presenter) in less than 100 lines."
  spec.summary       = spec.description
  spec.homepage      = "http://github.com/fnando/burgundy"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "pry-meta"
end
