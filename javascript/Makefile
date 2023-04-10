.PHONY: bump_major bump_minor bump_patch setup update clean test lint verify_transpiled_checkin build publish
SHELL:=/bin/bash

# Versions can be manually changed where they appear in the package json and
# package lock json, or updated in the package json and run `npm i`. These
# recipes are a reminder that the lock file must be updated or packaging will
# throw an error on the lock file being out of date.

bump_major:
	npm version major
	npm i --package-lock-only

bump_minor:
	npm version minor
	npm i --package-lock-only

bump_patch:
	npm version patch
	npm i --package-lock-only

# https://docs.npmjs.com/cli/v8/commands/npm-ci
setup:
	npm list -g --depth 0
	npm ci
	npm list

# https://docs.npmjs.com/cli/v8/commands/npm-outdated
# https://docs.npmjs.com/cli/v8/commands/npm-install
update:
	npm outdated
	npm install

clean:
	rm -f skenvy-collatz-*.tgz
	rm -rf docs
	npm run clean

docs:
	npm run docs

# https://docs.npmjs.com/cli/v8/commands/npm-test
# https://docs.npmjs.com/cli/v8/commands/npm-publish
test: clean
	npm test
	npm publish --dry-run

lint:
	TIMING=1 npm run lint

# Confirm that the checked in lib folder's contents are what would be generated
# from transpiling the checked in typescript, to make sure they're in sync.
verify_transpiled_checkin: clean
	npm run build
	echo "Exit if a change to the transpiled JavaScript is not committed"
	git add lib && git diff --exit-code --cached --stat -- lib/

# https://docs.npmjs.com/cli/v8/commands/npm-pack
build: clean test lint verify_transpiled_checkin
	npm pack

# https://docs.npmjs.com/cli/v8/commands/npm-publish
publish:
	npm publish --access=public skenvy-collatz-*.tgz
