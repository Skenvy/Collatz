.PHONY: clean_docs clean deps docs docs_test test build
SHELL:=/bin/bash
# Stop Pkg funcs from printing "nothing", and add a line
# SHH= 1> /dev/null && echo
# The redirect doesn't block prints from julia locally, but does appear to
# prevent the output from appearing in github actions, so removing $(SHH)

clean_docs:
	rm -rf docs/build/
	rm -rf docs/site/

clean: clean_docs
	rm -f deps/build.log
	rm -f Manifest.toml
	rm -f */Manifest.toml

# This includes Pkg.resolve() ~ which is ideologically mutually exclusive with
# committing the manifest, as resolve rebuilds the manifest from the project.
deps: clean
	julia --project=. -e "import Pkg; Pkg.resolve(); Pkg.instantiate();"
	julia --project=test -e "import Pkg; Pkg.resolve(); Pkg.instantiate();"
	julia --project=docs -e "import Pkg; Pkg.develop(Pkg.PackageSpec(path=pwd())); Pkg.resolve(); Pkg.instantiate();"

docs: clean_docs
	julia --project=docs -e "using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()"
	julia --project=docs docs/make.jl

docs_test: docs
	julia --project=docs -e "using Documenter: doctest; using Collatz; doctest(Collatz)"

docs_view: docs_test
	julia --project=docs -e "using LiveServer; serve(dir=\"docs/build\")"

test:
	julia --project=. -e "import Pkg; Pkg.test();"

build: test docs_test
	julia --project=. -e "import Pkg; Pkg.build();"
