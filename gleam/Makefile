.PHONY: clean setup format test test_js build run publish
SHELL:=/bin/bash

clean:
	rm ./collatz

setup:
	gleam deps download

format:
	gleam format --check src test

test:
	gleam test

test_js:
	gleam test --target javascript

# Required `gleam add --dev gleescript`
build:
	gleam run -m gleescript
	chmod +x ./collatz

# gleam run ARGS
# ./<bundled_script> ARGS
run:
	gleam run

publish:
	gleam publish -y
