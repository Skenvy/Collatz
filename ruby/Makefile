# It's assumed you have https://rvm.io/ -- see "Developing" in the README
# https://github.com/Skenvy/Collatz/blob/main/ruby/README.md#developing

# ruby binaries -- https://rvm.io/binaries/ ~= ubuntu 24 x86
DEVELOPMENT_RUBY_VERSION=ruby-3.3.6
# https://rubygems.org/gems/bundler
DEVELOPMENT_BUNDLER_VERSION=2.5.23
# https://rubygems.org/gems/rubygems-update
DEVELOPMENT_GEMSYS_VERSION=3.6.5

RVM=source "$$RVM_DIR/scripts/rvm" && rvm
INSTALL_RUBY=$(RVM) install "$(DEVELOPMENT_RUBY_VERSION)"
_=$(RVM) use $(DEVELOPMENT_RUBY_VERSION) &&
GEM=$(_) gem
INSTALL_BUNDLER=$(GEM) install bundler -v $(DEVELOPMENT_BUNDLER_VERSION)
UPDATE_RUBYGEMS=$(GEM) update --system $(DEVELOPMENT_GEMSYS_VERSION)
# With multiple bundler versions installed, specify which to use with _ver_
BUNDLE=$(_) bundle _$(DEVELOPMENT_BUNDLER_VERSION)_
RAKE=$(BUNDLE) exec rake

.PHONY: initialise setup setup_github clean docs test build install push_rubygems push_github
SHELL:=/bin/bash

# How to setup for ruby development ~ might require compiling ruby locally.
initialise:
	$(INSTALL_RUBY)
	$(INSTALL_BUNDLER)
	$(UPDATE_RUBYGEMS)

setup: initialise
	$(BUNDLE) install

setup_github:
	$(GEM) install keycutter

clean:
	$(RAKE) clean
	$(RAKE) clobber
	rm -f collatz-*.gem
	rm -f pkg/collatz-*.gem

docs: clean
	$(RAKE) rdoc

# default (just `rake`) is spec + rubocop, but be pedantic in case this changes.
test: clean
	$(RAKE) spec
	$(RAKE) rubocop

# We can choose from `gem build collatz.gemspec` or `bundle exec rake build`.
# The gem build command creates a ./collatz-$VER.gem file, and the rake build
# (within bundle context) creates a ./pkg/collatz-$VER.gem file.
build: test
	$(RAKE) build

# --user-install means no need for sudo or expectation of
# changing the folder permissions or access but will need
# "gem environment"'s "USER INSTALLATION DIRECTORY" (+ "/bin")
# in the PATH to then use any gem executables that it may contain.
install: build
	$(GEM) install ./pkg/collatz-$$(grep lib/collatz/version.rb -e "VERSION" | cut -d \" -f 2).gem --user-install

# Will be run with one "pkg/collatz-*.gem" file
# rubygems_api_key and the rubygems host are the default
push_rubygems:
	$(GEM) push $$(find . | grep pkg/collatz-*.gem)

# Will be run with one "pkg/collatz-*.gem" file
push_github:
	$(GEM) push --key github --host https://rubygems.pkg.github.com/Skenvy $$(find . | grep pkg/collatz-*.gem)
