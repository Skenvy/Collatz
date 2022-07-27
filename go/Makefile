.PHONY: clean test build run
SHELL:=/bin/bash

clean:
	go clean .
	go clean ./collatz

# locally, if test fails on the tidy, running it again shouldn't fail tidy again.
# its intent is to catch an untidy mod in CI if not run before committing.
test: clean
	[[ -z "$$(go mod tidy -v 2>&1)" ]] && echo "go.mod file is tidy" || (echo "go.mod file needs a tidy" && exit 1)
	go test -v .

build: test
	go build -o collatz ./collatz

run: build
	./collatz/collatz
