# frozen_string_literal: true

require_relative "lib/toolcase/version"

Gem::Specification.new do |spec|
  spec.name          = "toolcase"
  spec.version       = Toolcase::VERSION
  spec.authors       = ["enchf"]

  spec.summary       = "Registry for handlers as a Strategy pattern implementation"
  spec.homepage      = "https://github.com/enchf/toolcase"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata['allowed_push_host'] = "https://rubygems.org"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  # Development & Testing dependencies.
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency 'minitest-reporters', '~> 1.4'
  spec.add_development_dependency 'mocha', '~> 1.13'
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 0.80"

  # Runtime dependencies.
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
