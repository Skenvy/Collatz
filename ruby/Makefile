.PHONY: setup clean test build install
SHELL:=/bin/bash

# Assumes `gem install bundler`
setup:
	bundle install

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
