.PHONY: clean check_src test build check_built run
SHELL:=/bin/bash

check_src:
	R CMD check .

test: check_src
	# TODO

build:
	R CMD build .

# Using -- R CMD check collatz_$$(grep DESCRIPTION -e "^Version:" | cut -d \  -f2).tar.gz
# At the moment yields a ".tar.gz’ is neither a file nor directory, skipping" error.
check_built: build
	R CMD check $$(ls | grep collatz_*.tar.gz)

run:
	Rscript R/Collatz.R
