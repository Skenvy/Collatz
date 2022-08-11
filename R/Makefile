.PHONY: clean test build check run
SHELL:=/bin/bash

# We'd "rm -rf ..Rcheck" or "rm -rf **Rcheck" if doing other "R CMD check"'s
clean:
	rm -rf $$(ls | grep collatz_*.tar.gz)
	rm -rf collatz.Rcheck

test: clean
	R CMD check --no-manual .
	# TODO TESTS

build: test
	R CMD build --no-manual .

# Using -- R CMD check collatz_$$(grep DESCRIPTION -e "^Version:" | cut -d \  -f2).tar.gz
# At the moment yields a ".tar.gz’ is neither a file nor directory, skipping" error.
# _R_CHECK_CRAN_INCOMING_=TRUE && --as-cran
# --no-manual to silence the current pdfLaTeX errors.
check: build
	R CMD check --no-manual $$(ls | grep collatz_*.tar.gz)

run:
	Rscript R/Collatz.R
