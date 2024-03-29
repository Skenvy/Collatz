.PHONY: repl clean_docs clean deps docs docs_deploy docs_view test build
SHELL:=/bin/bash

### These are just the CLI way of doing the common REPL commands to create a new project,
### although _all that's needed_ for a project is to create a blank `~/path/to/Project.toml`
# "Generate" will create a new project and src in `~/d/`
# $> julia --project=a/b/c -e "using Pkg; Pkg.generate(\"d\");"
# A _single_ "instantiate" will create only `~/a/b/c/Manifest.toml`
# $> julia --project=a/b/c -e "using Pkg; Pkg.instantiate();"
# _Two_ "instantiate"'s, or a resolve as well, will generate the project along with the manifest.
# $> julia --project=a/b/c -e "using Pkg; Pkg.instantiate(); Pkg.instantiate();"
# $> julia --project=a/b/c -e "using Pkg; Pkg.resolve(); Pkg.instantiate();"
# To _add_ a package ~
# $> julia --project=a/b/c -e "using Pkg; Pkg.add(\"PkgName\")"
# To _see_ the packages (and their versions, for compat) ~
# $> julia --project=a/b/c -e "using Pkg; Pkg.status()"

repl:
	julia --project=. -e "import Pkg; Pkg.resolve(); Pkg.instantiate(); using Collatz" -i

clean_docs:
	rm -rf docs/build/
	rm -rf docs/site/

clean: clean_docs
	rm -f deps/build.log
	rm -f Manifest.toml
	rm -f */Manifest.toml

# This includes Pkg.resolve() ~ which is ideologically mutually exclusive with
# committing the manifest, as resolve rebuilds the manifest from the project.
# Pkg.develop(Pkg.PackageSpec(path=pwd())) included in docs to add 'this' to it.
deps: clean
	julia --project=. -e "import Pkg; Pkg.resolve(); Pkg.instantiate();"
	julia --project=test -e "import Pkg; Pkg.resolve(); Pkg.instantiate();"
	julia --project=docs -e "import Pkg; Pkg.develop(Pkg.PackageSpec(path=pwd())); Pkg.resolve(); Pkg.instantiate();"
	julia --project=docs/view -e "import Pkg; Pkg.resolve(); Pkg.instantiate();"

docs: clean_docs
	julia --project=docs -e "using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.resolve(); Pkg.instantiate()"
	julia --project=docs --code-coverage=user docs/make.jl

docs_deploy: docs
	julia --project=docs --code-coverage=user docs/deploy.jl

# The docs_test is already a step in docs, and can yield an error forcefully by setting strict to true
# in makedocs so docs_test is only useful as a test step if wanting to not rebuild with makedocs.
# doctest is simply asserting the truth of ```jldoctest blocks in the `~/docs/src/*.md` files.
# docs_test:
# 	julia --project=docs -e "using Documenter: doctest; using Collatz; @time doctest(Collatz)"
# < However, it's now problematic to maintain both, as makedocs uses the setdocmeta! to `using Collatz`

docs_view: docs
	julia --project=docs/view -e "using LiveServer; serve(dir=\"docs/build\")"

test:
	julia --project=. -e "import Pkg; @time Pkg.precompile(); @time Pkg.test();"

build: test docs
	julia --project=. -e "import Pkg; @time Pkg.build();"
