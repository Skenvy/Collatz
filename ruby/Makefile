.PHONY: setup clean test build
SHELL:=/bin/bash

# Assumes `gem install bundler`
setup:
	bundle install

clean:
	rm collatz-*.gem

test: clean
	bundle exec rake

build: test
	gem build collatz.gemspec
