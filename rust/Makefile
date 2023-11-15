.PHONY: setup clean docs test fmt clippy clippy_fix lint build publish run
SHELL:=/bin/bash

# Makefile Examples Here:
# https://github.com/redis-rs/redis-rs/blob/main/Makefile

# https://docs.rs/
# https://doc.rust-lang.org/cargo/commands/index.html

setup:
	rustup toolchain install nightly
	rustup toolchain install stable
	rustup component add rustfmt
	rustup component add clippy

clean:
	cargo clean

docs: clean
	cargo doc --no-deps --document-private-items -v

test:
	cargo test --verbose

# https://doc.rust-lang.org/nightly/clippy/lint_configuration.html
# https://rust-lang.github.io/rust-clippy/master/index.html#/

fmt:
	cargo +stable fmt --verbose --all --check

clippy:
	cargo +stable clippy --all-targets --all-features -- -D warnings

clippy_fix:
	cargo +stable clippy --all-targets --all-features --fix

lint: fmt clippy

build:
	cargo build --verbose

publish:
	cargo publish

run:
	cargo run
