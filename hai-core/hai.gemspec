# frozen_string_literal: true

require_relative "lib/hai/version"
version = File.read(File.expand_path("../VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name = "hai"
  spec.version = version
  spec.authors = ["basicbrogrammer"]
  spec.email = ["basicbrogrammer@pm.me"]

  spec.summary = "A CRUD api built on ActiveRecord"
  spec.description = "Will finish later."
  spec.homepage = "https://github.com/basicbrogrammer/hai"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/basicbrogrammer"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files = Dir["{app,config,lib}/**/*"]

  spec.files =
    Dir.chdir(File.expand_path(__dir__)) do
      `git ls-files -z`.split("\x0")
        .reject do |f|
          (f == __FILE__) ||
            f.match(
              %r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)}
            )
        end
    end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib app config]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "activerecord", "~> 7.0"
  spec.add_dependency "graphql", "~> 2.0"
  spec.add_dependency "pg", "~> 1.3.5"
  spec.add_development_dependency "activesupport", "~> 7.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
