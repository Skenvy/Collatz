.PHONY: clean test build
SHELL:=/bin/bash

clean:
	go clean ./src
	go clean ./collatz

test: clean
	go test -v ./src

build: test
	go build -o collatz ./collatz
