R_=Rscript -e '
_R='
ifeq ($(OS),Windows_NT)
BIN_PATH=PATH=$$PATH:$$($(R_)tinytex::tinytex_root()$(_R) | cut -d \  -f2 | sed 's|"||g' | sed 's|\\\\|/|g' | sed 's|C:|/c|g')/bin/win32 && echo $$PATH && 
else
BIN_PATH=PATH=$$PATH:~/.local/bin:~/bin && 
endif
NO_SUGGESTS=_R_CHECK_FORCE_SUGGESTS_=false 
.PHONY: setup_debian setup_debian_gmp setup_user_lib setup setup_libraries setup_mac_tests setup_win_tests setup_docs clean manRd docs docs_local test cmd_check full_test build check wincheck quick_check install run
SHELL:=/bin/bash

# A partially complete list of packages you might need to install to
# get the installation of devtools to work on ubuntu. Also possibly
# with a slow connection you might need to attempt installing stringi
# seperately from the rest as it seems to often timeout. This isn't
# exhaustive, so you might need to install other missing deps.
setup_debian:
	apt update && apt -y install libcurl4-openssl-dev libssl-dev libxml2-dev \
	libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev \
	libpng-dev libtiff5-dev libjpeg-dev pandoc texinfo qpdf

setup_debian_gmp:
	apt update && apt install -y libgmp-dev

# Create or use user / local install location
# See `Rscript -e 'help(Startup)'` for an outline of R session initialisation.
# As far as this goes, you can `Rscript -e 'print(.libPaths())'` to see a list
# of all paths for library install locations. Alternatively you can try either
# `Rscript -e 'print(.Library)'` or `Rscript -e 'print(.Library.site)'`, but
# the `.Library` result should be a subset of the `.Library.site`, which should
# be a subset of the `.libPaths()` list of library install locations. Running
# `Rscript -e 'print(Sys.getenv("R_LIBS_USER"))'` will show the `R_LIBS_USER`.
# Rscript -e 'print(.libPaths())'
setup_user_lib:
	$(R_)dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)$(_R)
	$(R_).libPaths(Sys.getenv("R_LIBS_USER"))$(_R)

# Devlopment packages.
setup: setup_user_lib
	$(R_)install.packages(c("roxygen2", "testthat"))$(_R)
	$(R_)install.packages("devtools")$(_R)
	$(R_)install.packages(c("covr", "DT"))$(_R)
	$(R_)install.packages(c("pkgdown", "servr"))$(_R)
	$(R_)install.packages(c("tinytex", "knitr", "rmarkdown"))$(_R)
	$(R_)tinytex::install_tinytex()$(_R)
	$(R_)tinytex::tlmgr_install("makeindex")$(_R)

# Create or use user / local install location
# Included packages
setup_libraries: setup_user_lib
	$(R_)install.packages(c("gmp", "testthat"))$(_R)

setup_mac_tests: setup_libraries
	$(R_)install.packages(c("testthat", "roxygen2", "devtools", "covr", "DT", "pkgdown", "servr", "knitr", "rmarkdown"), type="binary")$(_R)

# Locally something like 'C:\Program Files\R\R-4.2.1\bin\Rscript.exe'
# In GHA, installed with /DIR=C:\R -- so 'C:\R\R-$VER\bin\Rscript.exe'
# For installing locall we'd need to reference $(R_PATH)\bin\Rscript.exe -e "~"
# But in GHA, the rtools bash let's us just 'Rscript -e "~"' <-- also
# worth mentioning it does also require the outer quotes to be " not '
setup_win_tests:
	Rscript -e "install.packages(c('gmp', 'testthat'), type='binary', repos='http://cran.us.r-project.org')"
	Rscript -e "install.packages(c('roxygen2', 'devtools', 'covr', 'DT', 'pkgdown', 'servr', 'knitr', 'rmarkdown', 'tinytex'), type='binary', repos='http://cran.us.r-project.org')"
	$(R_)tinytex::install_tinytex()$(_R)
	$(R_)tinytex::tinytex_root()$(_R)
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
	$(R_)devtools::document()$(_R)
	echo "Exit if a change to the documentation is not committed"
	git diff | cat
	git diff --exit-code --stat -- DESCRIPTION
	git diff --exit-code --stat -- NAMESPACE
	git add man && git diff --exit-code --cached --stat -- man/

docs: manRd
	$(R_)pkgdown::build_site()$(_R)
	mkdir docs/pdf -p
	$(BIN_PATH) $(R_)Sys.which("makeindex")$(_R)
	$(BIN_PATH) $(R_)devtools::build_manual(path="./docs/pdf")$(_R)
	$(BIN_PATH) $(R_)covr::report(file = file.path("./docs/covr", "Collatz-report.html"))$(_R)

# http://127.0.0.1:4321/
# http://127.0.0.1:4321/pdf/ -- collatz_$VER.pdf
# http://127.0.0.1:4321/covr/Collatz-report.html
docs_local: docs
	$(R_)servr::httd(dir="./docs")$(_R)

test: clean
	$(NO_SUGGESTS) $(R_)devtools::test()$(_R)

cmd_check: clean
	$(NO_SUGGESTS) R CMD check --no-manual .

full_test: test cmd_check

build: clean
	R CMD build .

# Using -- R CMD check collatz_$$(grep DESCRIPTION -e "^Version:" | cut -d \  -f2).tar.gz
# At the moment yields a ".tar.gz’ is neither a file nor directory, skipping" error.
# _R_CHECK_CRAN_INCOMING_=TRUE &| --as-cran
check: full_test manRd build
	$(BIN_PATH) R CMD check --as-cran $$(ls | grep collatz_*.tar.gz)

quick_check: cmd_check build
	$(NO_SUGGESTS) R CMD check --no-manual $$(ls | grep collatz_*.tar.gz)

install: build
	R CMD INSTALL $$(ls | grep collatz_*.tar.gz)

run:
	Rscript R/Collatz.R
