.PHONY: setup_debian setup clean test build check run
SHELL:=/bin/bash

# A partially complete list of packages you might need to install to
# get the installation of devtools to work on ubunut. Also possibly
# with a slow connection you might need to attempt installing stringi
# seperately from the rest as it seems to often timeout. This isn't
# exhaustive, so you might need to install other missing deps.
# sudo make setup_debian
setup_debian:
	apt update && apt -y install libcurl4-openssl-dev libssl-dev libxml2-dev \
	libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev \
	libpng-dev libtiff5-dev libjpeg-dev

setup:
	# Create or use user / local install location
	Rscript -e 'dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)'
	Rscript -e '.libPaths(Sys.getenv("R_LIBS_USER"))'
	# Devlopment packages
	Rscript -e 'install.packages("devtools")'
	Rscript -e 'install.packages("roxygen2")'
	Rscript -e 'install.packages("testthat")'
	# Included packages
	Rscript -e 'install.packages("gmp")'

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
