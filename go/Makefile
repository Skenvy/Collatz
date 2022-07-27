.PHONY: clean test build run
SHELL:=/bin/bash

clean:
	go clean .
	go clean ./collatz

test: clean
	go test -v .

build: test
	go build -o collatz ./collatz

run: build
	./collatz/collatz
