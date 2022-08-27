.PHONY: setup_debian setup_debian_350 setup setup_libraries setup_mac_tests setup_win_tests setup_docs clean manRd docs docs_local test cmd_check full_test build check wincheck quick_check install run
SHELL:=/bin/bash
LOCALBIN=PATH=$$PATH:~/.local/bin:~/bin && 
WINTEX=PATH=$$PATH:$$APPDATA/TinyTeX
NO_SUGGESTS=_R_CHECK_FORCE_SUGGESTS_=false 

# A partially complete list of packages you might need to install to
# get the installation of devtools to work on ubunut. Also possibly
# with a slow connection you might need to attempt installing stringi
# seperately from the rest as it seems to often timeout. This isn't
# exhaustive, so you might need to install other missing deps.
# sudo make setup_debian
setup_debian:
	apt update && apt -y install libcurl4-openssl-dev libssl-dev libxml2-dev \
	libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev \
	libpng-dev libtiff5-dev libjpeg-dev pandoc texinfo qpdf

setup_debian_350:
	apt update && apt install -y libgmp-dev

# Create or use user / local install location
# Devlopment packages.
setup:
	Rscript -e 'dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)'
	Rscript -e '.libPaths(Sys.getenv("R_LIBS_USER"))'
	Rscript -e 'install.packages(c("roxygen2", "testthat"))'
	Rscript -e 'install.packages("devtools")'
	Rscript -e 'install.packages(c("covr", "DT"))'
	Rscript -e 'install.packages(c("pkgdown", "servr"))'
	Rscript -e 'install.packages(c("tinytex", "knitr", "rmarkdown"))'
	Rscript -e 'tinytex::install_tinytex()'
	Rscript -e 'tinytex::tlmgr_install("makeindex")'

# Create or use user / local install location
# Included packages
setup_libraries:
	Rscript -e 'dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)'
	Rscript -e '.libPaths(Sys.getenv("R_LIBS_USER"))'
	Rscript -e 'install.packages("gmp")'

setup_mac_tests: setup_libraries
	Rscript -e 'install.packages(c("testthat", "roxygen2", "devtools", "covr", "DT", "pkgdown", "servr", "knitr", "rmarkdown"), type="binary")'

# Locally something like 'C:\Program Files\R\R-4.2.1\bin\Rscript.exe'
# In GHA, installed with /DIR=C:\R -- so 'C:\R\R-$VER\bin\Rscript.exe'
# For installing locall we'd need to reference $(R_PATH)\bin\Rscript.exe -e "~"
# But in GHA, the rtools bash let's us just 'Rscript -e "~"' <-- also
# worth mentioning it does also require the outer quotes to be " not '
setup_win_tests:
	Rscript -e "install.packages(c('gmp', 'testthat'), type='binary', repos='http://cran.us.r-project.org')"
	Rscript -e "install.packages(c('roxygen2', 'devtools', 'covr', 'DT', 'pkgdown', 'servr', 'knitr', 'rmarkdown', 'tinytex'), type='binary', repos='http://cran.us.r-project.org')"
	Rscript -e 'tinytex::install_tinytex()'
	Rscript -e "tinytex::tlmgr_install('makeindex')"

setup_docs:
	apt update && apt -y install pandoc texinfo qpdf
	make setup
	make setup_libraries

clean:
	rm -rf $$(ls | grep collatz_*.tar.gz)
	rm -rf ..Rcheck
	rm -rf **Rcheck
	rm -rf .Rd2pdf*
	rm -rf docs
	rm -rf doc
	rm -rf Meta

# The following steps assume that the setup has been run already.

manRd: clean
	Rscript -e 'devtools::document()'
	echo "Exit if a change to the documentation is not committed"
	git diff --exit-code --stat -- DESCRIPTION
	git diff --exit-code --stat -- NAMESPACE
	git add man && git diff --exit-code --cached --stat -- man/

docs: manRd
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
	$(NO_SUGGESTS) Rscript -e 'devtools::test()'

cmd_check: clean
	$(NO_SUGGESTS) R CMD check --no-manual .

full_test: test cmd_check

build: clean
	R CMD build .

# Using -- R CMD check collatz_$$(grep DESCRIPTION -e "^Version:" | cut -d \  -f2).tar.gz
# At the moment yields a ".tar.gz’ is neither a file nor directory, skipping" error.
# _R_CHECK_CRAN_INCOMING_=TRUE &| --as-cran
check: full_test manRd build
	$(LOCALBIN) R CMD check --as-cran $$(ls | grep collatz_*.tar.gz)

wincheck: full_test manRd build
	R CMD check --as-cran $$(ls | grep collatz_*.tar.gz)

quick_check: cmd_check build
	$(NO_SUGGESTS) R CMD check --no-manual $$(ls | grep collatz_*.tar.gz)

install: build
	R CMD INSTALL $$(ls | grep collatz_*.tar.gz)

run:
	Rscript R/Collatz.R
