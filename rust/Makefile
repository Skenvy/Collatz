.PHONY: setup clean docs test lint build publish run
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

docs:
	cargo doc

test:
	cargo test --verbos

# https://doc.rust-lang.org/nightly/clippy/lint_configuration.html
# https://rust-lang.github.io/rust-clippy/master/index.html#/
lint:
	cargo +stable fmt --verbose --all --check
	cargo +stable clippy --all-targets --all-features

build:
	cargo build --verbose

publish:
	cargo publish

run:
	cargo run
