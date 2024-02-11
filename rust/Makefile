DEVELOPMENT_VERSION=1.73
CARGO=cargo +$(DEVELOPMENT_VERSION)
.PHONY: setup clean docs test fmt clippy clippy_fix lint build publish run
SHELL:=/bin/bash

# Makefile Examples Here:
# https://github.com/redis-rs/redis-rs/blob/main/Makefile

# https://docs.rs/
# https://doc.rust-lang.org/cargo/commands/index.html

setup:
	rustup toolchain install $(DEVELOPMENT_VERSION)
	rustup toolchain install nightly
	rustup toolchain install stable
	rustup component add rustfmt
	rustup component add clippy

clean:
	$(CARGO) clean

docs: clean
	$(CARGO) doc --no-deps --document-private-items -v

test:
	$(CARGO) test --verbose

# https://doc.rust-lang.org/nightly/clippy/lint_configuration.html
# https://rust-lang.github.io/rust-clippy/master/index.html#/

fmt:
	$(CARGO) fmt --verbose --all --check

clippy:
	$(CARGO) clippy --all-targets --all-features -- -D warnings

clippy_fix:
	$(CARGO) clippy --all-targets --all-features --fix

lint: fmt clippy

build:
	$(CARGO) build --verbose

publish:
	$(CARGO) publish

run:
	$(CARGO) run
