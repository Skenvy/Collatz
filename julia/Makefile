.PHONY: deps test build
SHELL:=/bin/bash

# This includes Pkg.resolve() ~ which is ideologically mutually exclusive with
# committing the manifest, as resolve rebuilds the manifest from the project.
deps:
	julia --project=. -E "import Pkg; Pkg.resolve(); Pkg.instantiate()"
	julia --project=test -E "import Pkg; Pkg.resolve(); Pkg.instantiate()"

test:
	julia --project=. -E "import Pkg; Pkg.test()"

build: test
	julia --project=. -E "import Pkg; Pkg.build()"
