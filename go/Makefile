GOENV=export GOPATH=~/go && export GOBIN=~/go/bin && 
TIDY=go mod tidy
GODOC_VER=v0.1.11
PKGSITE_VER=v0.0.0-20220719173606-91f9f1ec61b0
.PHONY: godoc docs docs_local docs_view pkgsite clean test build run publish
SHELL:=/bin/bash

# ALL docs recipes at the moment rely on but expects godoc to have been run independently as a project setup to not require its rebuilding constantly
godoc:
	$(GOENV) go get golang.org/x/tools/cmd/godoc@$(GODOC_VER) && go install ~/go/pkg/mod/golang.org/x/tools@$(GODOC_VER)/cmd/godoc/ && $(TIDY)

# We let docs require test to generate the coverage output file c.out
docs: test
	mkdir docs/lib/godoc -p
	~/go/bin/godoc -goroot $$(pwd) -url /pkg/github.com/Skenvy/Collatz/go/ > docs/index.html
	# Remove the first line directed to the file.
	sed -i '1d' docs/index.html
	# sed the html to make the href's relative, otherwise they don't work on gh pages.
	sed -i 's|"/lib/godoc|"./lib/godoc|g' docs/index.html
	cp -f ~/go/pkg/mod/golang.org/x/tools@$(GODOC_VER)/godoc/static/**.css docs/lib/godoc/
	cp -f ~/go/pkg/mod/golang.org/x/tools@$(GODOC_VER)/godoc/static/**.js docs/lib/godoc/
	# Add the coverage from the test's c.out
	go tool cover -html=coverage.out -o docs/coverage.html

# Runs the ./docs/main.go from . and then targets ./docs internally
# http://localhost:3000/ and http://localhost:3000/coverage.html
docs_local: docs
	go run ./docs

# http://localhost:6060/pkg/github.com/Skenvy/Collatz/go/
docs_view:
	~/go/bin/godoc -http=:6060 -goroot $$(pwd) -play

# build golang.org/x/pkgsite/cmd/pkgsite: cannot load embed: malformed module path "embed": missing dot in first path element
# Requires go 1.16+ ~ https://pkg.go.dev/embed?tab=versions
pkgsite:
	$(GOENV) go get golang.org/x/pkgsite/cmd/pkgsite@$(PKGSITE_VER) && go install ~/go/pkg/mod/golang.org/x/pkgsite@$(PKGSITE_VER)/cmd/pkgsite/ && $(TIDY)

clean:
	go clean .
	go clean ./collatz

# The intent is to catch an untidy mod in CI if not run before committing,
# and if not automatically done by the IDE / plugin.
format: clean
	[[ -z "$$(gofmt -l .)" ]] && echo "All **.go files already formatted" || (echo "These **.go files need a 'gofmt -w .'" && echo "$$(gofmt -l .)" && exit 1)
	[[ -z "$$(go vet ./...)" ]] && echo "All **.go files already vetted" || (echo "These **.go files need a 'go vet -json ./...'" && echo "$$(go vet -json ./...)" && exit 1)
	[[ -z "$$($(TIDY) -v 2>&1)" ]] && echo "go.mod file is tidy" || (echo "go.mod file needs a '$(TIDY)'" && exit 1)
	# TODO: Add staticcheck when upping version from 13 to 17.

test: clean
	go test -coverprofile=coverage.out -v .
	go tool cover -func=coverage.out

build: test
	go build -o collatz ./collatz

run: build
	./collatz/collatz 27

publish:
	GOPROXY=proxy.golang.org go list -m github.com/Skenvy/Collatz/go@go-v$$(cat go.ver)
