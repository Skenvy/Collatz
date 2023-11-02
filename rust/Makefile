.PHONY: setup run
SHELL:=/bin/bash

# Makefile Examples Here:
# https://github.com/redis-rs/redis-rs/blob/main/Makefile
# https://gist.github.com/jlgerber/0f280236c2ee1b741dfe41a38d39a467
# https://github.com/KokaKiwi/rust-mk/blob/master/rust.mk

# https://github.com/rust-lang/rustfmt
# https://github.com/rust-lang/rust-clippy
# https://docs.rs/
# https://doc.rust-lang.org/cargo/commands/index.html

setup:
	cargo build

clean:

docs:
	cargo doc

test:
	cargo test --verbose

build:
	cargo build --verbose

publish:
	cargo publish

run:
	cargo run
