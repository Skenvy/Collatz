.PHONY: setup clean test build install
SHELL:=/bin/bash

# Assumes `gem install bundler`
setup:
	bundle install

clean:
	rm -f collatz-*.gem

test: clean
	bundle exec rake

build: test
	gem build collatz.gemspec

# --user-install means no need for sudo or expectation of
# changing the folder permissions or access but will need
# "gem environment"'s "USER INSTALLATION DIRECTORY" (+ "/bin")
# in the PATH to then use any gem executables that it may contain.
install: build
	gem install ./collatz-$$(grep lib/collatz/version.rb -e "VERSION" | cut -d \" -f 2).gem --user-install
