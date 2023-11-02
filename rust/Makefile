.PHONY: setup clean docs test lint build publish run
SHELL:=/bin/bash

# Makefile Examples Here:
# https://github.com/redis-rs/redis-rs/blob/main/Makefile

# https://github.com/rust-lang/rust-clippy
# https://docs.rs/
# https://doc.rust-lang.org/cargo/commands/index.html

setup:
	rustup toolchain install nightly
	rustup toolchain install stable
	rustup component add rustfmt

clean:

docs:
	cargo doc

test:
	cargo test --verbose

lint:
	cargo +stable fmt --verbose --check

build:
	cargo build --verbose

publish:
	cargo publish

run:
	cargo run
