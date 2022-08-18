.PHONY: setup_debian setup setup_libraries setup_mac_tests setup_win_tests clean docs docs_local test full_test build check run
SHELL:=/bin/bash
LOCALBIN=PATH=$$PATH:~/.local/bin:~/bin && 

# A partially complete list of packages you might need to install to
# get the installation of devtools to work on ubunut. Also possibly
# with a slow connection you might need to attempt installing stringi
# seperately from the rest as it seems to often timeout. This isn't
# exhaustive, so you might need to install other missing deps.
# sudo make setup_debian
setup_debian:
	apt update && apt -y install libcurl4-openssl-dev libssl-dev libxml2-dev \
	libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev \
	libpng-dev libtiff5-dev libjpeg-dev pandoc texinfo

# Create or use user / local install location
# Devlopment packages.
setup:
	Rscript -e 'dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)'
	Rscript -e '.libPaths(Sys.getenv("R_LIBS_USER"))'
	Rscript -e 'install.packages(c("roxygen2", "testthat"))'
	Rscript -e 'install.packages("devtools")'
	Rscript -e 'install.packages(c("covr", "DT"))'
	Rscript -e 'install.packages(c("pkgdown", "servr"))'
	Rscript -e 'install.packages(c("tinytex", "knitr"))'
	Rscript -e 'tinytex::install_tinytex()'
	Rscript -e 'tinytex::tlmgr_install("makeindex")'

# Create or use user / local install location
# Included packages
setup_libraries:
	Rscript -e 'dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)'
	Rscript -e '.libPaths(Sys.getenv("R_LIBS_USER"))'
	Rscript -e 'install.packages("gmp")'

setup_mac_tests: setup_libraries
	Rscript -e 'install.packages("testthat", type="binary")'

# Locally something like 'C:\Program Files\R\R-4.2.1\bin\Rscript.exe'
# In GHA, installed with /DIR=C:\R -- so 'C:\R\R-$VER\bin\Rscript.exe'
setup_win_tests:
	$(R_PATH)\bin\Rscript.exe -e 'dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)'
	$(R_PATH)\bin\Rscript.exe -e '.libPaths(Sys.getenv("R_LIBS_USER"))'
	$(R_PATH)\bin\Rscript.exe -e 'install.packages(c("gmp", "testthat"), type="binary", repos="http://cran.us.r-project.org")'

clean:
	rm -rf $$(ls | grep collatz_*.tar.gz)
	rm -rf **Rcheck
	rm -rf .Rd2pdf*
	rm -rf man
	rm -rf docs

# The following steps assume that the setup has been run already.

docs: clean
	Rscript -e 'devtools::document()'
	Rscript -e 'pkgdown::build_site()'
	mkdir docs/pdf -p
	$(LOCALBIN) Rscript -e 'Sys.which("makeindex")'
	$(LOCALBIN) Rscript -e 'devtools::build_manual(path="./docs/pdf")'
	$(LOCALBIN) Rscript -e 'covr::report(file = file.path("./docs/covr", "Collatz-report.html"))'

# http://127.0.0.1:4321/
# http://127.0.0.1:4321/pdf/ -- collatz_$VER.pdf
# http://127.0.0.1:4321/covr/Collatz-report.html
docs_local: docs
	Rscript -e 'servr::httd(dir="./docs")'

test: clean
	_R_CHECK_FORCE_SUGGESTS_=0 Rscript -e 'devtools::test()'

full_test: test
	# We can avoid checking the pdf in full test as it should be test generated in docs
	_R_CHECK_FORCE_SUGGESTS_=0 R CMD check --no-manual .

build: full_test
	R CMD build .

# Using -- R CMD check collatz_$$(grep DESCRIPTION -e "^Version:" | cut -d \  -f2).tar.gz
# At the moment yields a ".tar.gz’ is neither a file nor directory, skipping" error.
# _R_CHECK_CRAN_INCOMING_=TRUE && --as-cran
# --no-manual to silence the current pdfLaTeX errors.
check: build
	R CMD check $$(ls | grep collatz_*.tar.gz)

run:
	Rscript R/Collatz.R
