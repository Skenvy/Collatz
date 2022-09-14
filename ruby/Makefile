.PHONY: setup setup_github clean test build install push_rubygems push_github
SHELL:=/bin/bash

# Assumes `gem install bundler`
setup:
	bundle install

setup_github:
	gem install keycutter

clean:
	bundle exec rake clean
	rm -f collatz-*.gem
	rm -f pkg/collatz-*.gem

test: clean
	bundle exec rake

# We can choose from `gem build collatz.gemspec` or `bundle exec rake build`.
# The gem build command creates a ./collatz-$VER.gem file, and the rake build
# (within bundle context) creates a ./pkg/collatz-$VER.gem file.
build: test
	bundle exec rake build

# --user-install means no need for sudo or expectation of
# changing the folder permissions or access but will need
# "gem environment"'s "USER INSTALLATION DIRECTORY" (+ "/bin")
# in the PATH to then use any gem executables that it may contain.
install: build
	gem install ./pkg/collatz-$$(grep lib/collatz/version.rb -e "VERSION" | cut -d \" -f 2).gem --user-install

# Will be run with one "pkg/collatz-*.gem" file
# rubygems_api_key and the rubygems host are the default
push_rubygems:
	gem push $$(find . | grep pkg/collatz-*.gem)

# Will be run with one "pkg/collatz-*.gem" file
push_github:
	gem push --key github --host https://rubygems.pkg.github.com/Skenvy $$(find . | grep pkg/collatz-*.gem)
