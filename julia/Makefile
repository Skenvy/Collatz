.PHONY: deps test build
SHELL:=/bin/bash
# Stop Pkg funcs from printing "nothing", and add a line
SHH= 1> /dev/null && echo

# This includes Pkg.resolve() ~ which is ideologically mutually exclusive with
# committing the manifest, as resolve rebuilds the manifest from the project.
deps:
	julia --project=. -E "import Pkg; Pkg.resolve(); Pkg.instantiate();" $(SHH)
	julia --project=test -E "import Pkg; Pkg.resolve(); Pkg.instantiate();" $(SHH)

test:
	julia --project=. -E "import Pkg; Pkg.test();" $(SHH)

build: test
	julia --project=. -E "import Pkg; Pkg.build();" $(SHH)
