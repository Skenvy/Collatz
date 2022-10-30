.PHONY: setup update clean test build publish
SHELL:=/bin/bash

# https://docs.npmjs.com/cli/v8/commands/npm-ci
# Requires 
setup:
	npm ci

# https://docs.npmjs.com/cli/v8/commands/npm-outdated
# https://docs.npmjs.com/cli/v8/commands/npm-install
update:
	npm outdated
	npm install

clean:
	rm -f skenvy-collatz-*.tgz

# https://docs.npmjs.com/cli/v8/commands/npm-test
# https://docs.npmjs.com/cli/v8/commands/npm-publish
test: clean setup
	npm test
	npm publish --dry-run

# https://docs.npmjs.com/cli/v8/commands/npm-pack
build: clean setup test
	npm pack

# https://docs.npmjs.com/cli/v8/commands/npm-publish
publish: clean
