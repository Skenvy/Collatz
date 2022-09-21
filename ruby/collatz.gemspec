# frozen_string_literal: true

require_relative "lib/collatz/version"

Gem::Specification.new do |spec|
  spec.name    = "collatz"
  spec.version = Collatz::VERSION
  spec.license = "Apache-2.0"
  spec.authors = ["Nathan Levett"]
  spec.email   = ["nathan.a.z.levett@gmail.com"]
  spec.summary = "Functions Related to the Collatz/Syracuse/3n+1 Problem"
  spec.description = "Provides the basic functionality to interact with the Collatz conjecture.
  The parameterisation uses the same (P,a,b) notation as Conway's generalisations.
  Besides the function and reverse function, there is also functionality to retrieve
  the hailstone sequence, the \"stopping time\"/\"total stopping time\", or tree-graph.
  The only restriction placed on parameters is that both P and a can't be 0."
  spec.homepage = "https://skenvy.github.io/Collatz/ruby/"
  spec.required_ruby_version = ">= 2.7.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Skenvy/Collatz/tree/main/ruby"
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
