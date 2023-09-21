RENV_=RENV_CONFIG_SANDBOX_ENABLED=FALSE
R_=$(RENV_) Rscript -e '
_R='
ifeq ($(OS),Windows_NT)
BIN_PATH=PATH=$$PATH:$$($(R_)tinytex::tinytex_root()$(_R) | cut -d \  -f2 | sed 's|"||g' | sed 's|\\\\|/|g' | sed 's|C:|/c|g')/bin/win32 && echo $$PATH && 
else
BIN_PATH=PATH=$$PATH:~/.local/bin:~/bin && 
endif
CRAN_REPO=repos="http://cran.us.r-project.org"
NO_SUGGESTS=_R_CHECK_FORCE_SUGGESTS_=false 
SHELL:=/bin/bash

################################################################################
# Setup debian dependencies

# A partially complete list of packages you might need to install to
# get the installation of devtools to work on ubuntu. Also possibly
# with a slow connection you might need to attempt installing stringi
# seperately from the rest as it seems to often timeout. This isn't
# exhaustive, so you might need to install other missing deps.
.PHONY: setup_debian
setup_debian:
	apt update && apt -y install libcurl4-openssl-dev libssl-dev libxml2-dev \
	libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev \
	libpng-dev libtiff5-dev libjpeg-dev pandoc texinfo qpdf

.PHONY: setup_debian_pdf
setup_debian_pdf:
	apt update && apt -y install pandoc texinfo qpdf

.PHONY: setup_debian_gmp
setup_debian_gmp:
	apt update && apt install -y libgmp-dev

################################################################################
# Setup R; install packages, and packages installers.

# Create or use user / local install location
# See `Rscript -e 'help(Startup)'` for an outline of R session initialisation.
# As far as this goes, you can `Rscript -e 'print(.libPaths())'` to see a list
# of all paths for library install locations. Alternatively you can try either
# `Rscript -e 'print(.Library)'` or `Rscript -e 'print(.Library.site)'`, but
# the `.Library` result should be a subset of the `.Library.site`, which should
# be a subset of the `.libPaths()` list of library install locations. Running
# `Rscript -e 'print(Sys.getenv("R_LIBS_USER"))'` will show the `R_LIBS_USER`.
# Rscript -e 'print(.libPaths())'
.PHONY: setup_user_lib
setup_user_lib:
	$(R_)dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)$(_R)
	$(R_).libPaths(Sys.getenv("R_LIBS_USER"))$(_R)

# Devlopment packages.
.PHONY: setup_development
setup_development: setup_user_lib
	$(R_)install.packages(c("roxygen2", "testthat"), $(CRAN_REPO))$(_R)
	$(R_)install.packages("devtools", $(CRAN_REPO))$(_R)
	$(R_)install.packages(c("covr", "DT"), $(CRAN_REPO))$(_R)
	$(R_)install.packages(c("pkgdown", "servr"), $(CRAN_REPO))$(_R)
	$(R_)install.packages(c("tinytex", "knitr", "rmarkdown"), $(CRAN_REPO))$(_R)

.PHONY: setup_tinytex
setup_tinytex:
	$(R_)tinytex::install_tinytex()$(_R)
	$(R_)tinytex::tlmgr_install("makeindex")$(_R)

# Depended packages
.PHONY: setup_dependencies
setup_dependencies: setup_user_lib
	$(R_)install.packages(c("gmp"), $(CRAN_REPO))$(_R)

# Roxygen and TestThat needed in CI
.PHONY: setup_test_dependencies
setup_test_dependencies: setup_user_lib
	$(R_)install.packages(c("roxygen2", "testthat"), $(CRAN_REPO))$(_R)

.PHONY: setup_everything
setup_everything: setup_debian_gmp setup_debian_pdf setup_development setup_tinytex setup_dependencies

################################################################################
# Alternate insall orders for mac and windows.

.PHONY: setup_mac_tests
setup_mac_tests: setup_dependencies
	$(R_)install.packages(c("testthat", "roxygen2", "devtools", "covr", "DT", "pkgdown", "servr", "knitr", "rmarkdown"), type="binary", $(CRAN_REPO))$(_R)

# Locally something like 'C:\Program Files\R\R-4.2.1\bin\Rscript.exe'
# In GHA, installed with /DIR=C:\R -- so 'C:\R\R-$VER\bin\Rscript.exe'
# For installing locally we'd need to reference $(R_PATH)\bin\Rscript.exe -e "~"
# But in GHA, the rtools bash let's us just 'Rscript -e "~"'
.PHONY: setup_win_tests
setup_win_tests:
	$(R_)install.packages(c("gmp", "testthat"), type="binary", $(CRAN_REPO))$(_R)
	$(R_)install.packages(c("roxygen2", "devtools", "covr", "DT", "pkgdown", "servr", "knitr", "rmarkdown", "tinytex"), type="binary", $(CRAN_REPO))$(_R)
	$(R_)tinytex::install_tinytex()$(_R)
	$(R_)tinytex::tinytex_root()$(_R)
	$(R_)tinytex::tlmgr_install("makeindex")$(_R)

################################################################################
# Pre build actions and tests

.PHONY: clean
clean:
	rm -rf $$(ls | grep collatz_*.tar.gz)
	rm -rf ..Rcheck
	rm -rf **Rcheck
	rm -rf .Rd2pdf*
	rm -rf docs
	rm -rf doc
	rm -rf Meta

# The following steps assume that the setup has been run already.
.PHONY: manRd
manRd: clean
	$(R_)devtools::document()$(_R)
	echo "Exit if a change to the documentation is not committed"
	git diff | cat
	git diff --exit-code --stat -- DESCRIPTION
	git diff --exit-code --stat -- NAMESPACE
	git add man && git diff --exit-code --cached --stat -- man/

.PHONY: docs
docs: manRd
	$(R_)pkgdown::build_site()$(_R)
	mkdir docs/pdf -p
	$(BIN_PATH) $(R_)Sys.which("makeindex")$(_R)
	$(BIN_PATH) $(R_)devtools::build_manual(path="./docs/pdf")$(_R)
	$(BIN_PATH) $(R_)covr::report(file = file.path("./docs/covr", "Collatz-report.html"))$(_R)

# http://127.0.0.1:4321/
# http://127.0.0.1:4321/pdf/ -- collatz_$VER.pdf
# http://127.0.0.1:4321/covr/Collatz-report.html
.PHONY: docs_local
docs_local: docs
	$(R_)servr::httd(dir="./docs")$(_R)

.PHONY: test
test: clean
	$(NO_SUGGESTS) $(R_)devtools::test()$(_R)

.PHONY: cmd_check
cmd_check: clean
	$(NO_SUGGESTS) R CMD check --no-manual .

################################################################################
# Build, post build, and tests

.PHONY: build
build: clean
	R CMD build .

# Using -- R CMD check collatz_$$(grep DESCRIPTION -e "^Version:" | cut -d \  -f2).tar.gz
# At the moment yields a ".tar.gz’ is neither a file nor directory, skipping" error.
# _R_CHECK_CRAN_INCOMING_=TRUE &| --as-cran
.PHONY: cran_check
cran_check: test cmd_check manRd build
	$(BIN_PATH) R CMD check --as-cran $$(ls | grep collatz_*.tar.gz)

.PHONY: check_not_cran_no_pdf
check_not_cran_no_pdf: test cmd_check build
	$(NO_SUGGESTS) R CMD check --no-manual $$(ls | grep collatz_*.tar.gz)

.PHONY: install
install: build
	R CMD INSTALL $$(ls | grep collatz_*.tar.gz)

.PHONY: run
run:
	Rscript R/Collatz.R
