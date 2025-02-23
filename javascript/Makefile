ifeq ($(OS),Windows_NT)
NVM=
_=
NPM=npm
INSTALL_NODE=
INSTALL_NPM=
else
NVM=source $$NVM_DIR/nvm.sh && nvm
_=$(NVM) use &&
NPM=$(_) npm
INSTALL_NODE=$(NVM) install $$(cat ./.nvmrc)
INSTALL_NPM=$(NPM) i -g npm@$$(cat ./.npm-version)
endif
PKG_NAME=skenvy-collatz
.PHONY: bump_major bump_minor bump_patch install_node install_npm setup update clean docs docs_server test lint verify_transpiled_checkin build publish demo _demo
SHELL:=/bin/bash

# Versions can be manually changed where they appear in the package json and
# package lock json, or updated in the package json and run `npm i`. These
# recipes are a reminder that the lock file must be updated or packaging will
# throw an error on the lock file being out of date.

bump_major:
	$(NPM) version major
	$(NPM) i --package-lock-only

bump_minor:
	$(NPM) version minor
	$(NPM) i --package-lock-only

bump_patch:
	$(NPM) version patch
	$(NPM) i --package-lock-only

install_node:
	$(INSTALL_NODE)

install_npm: install_node
	$(INSTALL_NPM)

# https://docs.npmjs.com/cli/v8/commands/npm-ci
setup: install_npm
	$(NPM) list -g --depth 0
	$(NPM) ci
	$(NPM) list

# https://docs.npmjs.com/cli/v8/commands/npm-outdated
# https://docs.npmjs.com/cli/v8/commands/npm-update
# https://docs.npmjs.com/cli/v8/commands/npm-install
# If outdated fails, try install. If outdated still fails, manually run `npm up`
update:
	$(NPM) outdated
	$(NPM) install

clean:
	rm -f $(PKG_NAME)-*.tgz
	rm -rf docs
	rm -rf .nyc_output
	$(NPM) run clean

docs:
	$(NPM) run docs

# http://127.0.0.1:8080/docs/tsdoc
# http://127.0.0.1:8080/docs/coverage
docs_server: docs
	$(NPM) run docs:server

# https://docs.npmjs.com/cli/v8/commands/npm-test
# https://docs.npmjs.com/cli/v8/commands/npm-publish
test: clean
	$(NPM) test
	$(NPM) publish --dry-run

lint:
	$(_) TIMING=1 npm run lint

# Confirm that the checked in lib folder's contents are what would be generated
# from transpiling the checked in typescript, to make sure they're in sync.
verify_transpiled_checkin: clean
	$(NPM) run build
	echo "Exit if a change to the transpiled JavaScript is not committed"
	git add lib && git diff --exit-code --cached --stat -- lib/

# https://docs.npmjs.com/cli/v8/commands/npm-pack
build: clean test lint verify_transpiled_checkin
	$(NPM) pack

# https://docs.npmjs.com/cli/v8/commands/npm-publish
publish:
	$(NPM) publish --access=public $(PKG_NAME)-*.tgz

demo: build
	mv $(PKG_NAME)-*.tgz .demo/$(PKG_NAME).tgz
	cd .demo && npm run everything

_demo: # packless demo to rerun it while manually tweaking it
	cd .demo && npm run everything
