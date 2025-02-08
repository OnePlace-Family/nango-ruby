require_relative "lib/nango/version"

Gem::Specification.new do |spec|
  spec.name          = "nango-ruby"
  spec.version       = Nango::VERSION
  spec.authors       = ["Matthew"]
  spec.email         = ["matthew@oncontinuum.com"]

  spec.summary       = "Nango API + Ruby! 🤖❤️"
  spec.homepage      = "https://github.com/OnePlace-Family/nango-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 1"
  spec.add_dependency "faraday-multipart", ">= 1"
  spec.metadata["rubygems_mfa_required"] = "true"
end
