.PHONY: deps test build
SHELL:=/bin/bash
# Stop Pkg funcs from printing "nothing", and add a line
# SHH= 1> /dev/null && echo
# The redirect doesn't block prints from julia locally, but does appear to
# prevent the output from appearing in github actions, so removing $(SHH)

# This includes Pkg.resolve() ~ which is ideologically mutually exclusive with
# committing the manifest, as resolve rebuilds the manifest from the project.
deps:
	julia --project=. -E "import Pkg; Pkg.resolve(); Pkg.instantiate();"
	julia --project=test -E "import Pkg; Pkg.resolve(); Pkg.instantiate();"

test:
	julia --project=. -E "import Pkg; Pkg.test();"

build: test
	julia --project=. -E "import Pkg; Pkg.build();"
