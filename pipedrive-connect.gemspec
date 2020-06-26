# frozen_string_literal: true

$LOAD_PATH.unshift(::File.join(::File.dirname(__FILE__), "lib"))

require "pipedrive/version"

Gem::Specification.new do |spec|
  spec.name          = "pipedrive-connect"
  spec.version       = Pipedrive::VERSION
  spec.authors       = "Get on Board"
  spec.email         = "team@getonbrd.com"

  spec.summary       = "Ruby binding for the pipedrive API."
  spec.description   = "Ruby binding for the pipedrive API."
  spec.homepage      = "https://github.com/getonbrd/pipedrive-connect"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/getonbrd/pipedrive-connect"
  spec.metadata["changelog_uri"] = "https://github.com/getonbrd/pipedrive-connect/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # dependencies
  spec.add_dependency("faraday")
end
