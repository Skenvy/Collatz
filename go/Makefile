GOENV=export GOPATH=~/go && export GOBIN=~/go/bin && 
TIDY=go mod tidy
GODOC_VER=v0.1.11
PKGSITE_VER=v0.0.0-20220719173606-91f9f1ec61b0
.PHONY: godoc docs docs_local docs_view pkgsite clean test build run publish
SHELL:=/bin/bash

# ALL docs recipes at the moment rely on but expects godoc to have been run independently as a project setup to not require its rebuilding constantly
godoc:
	$(GOENV) go get golang.org/x/tools/cmd/godoc@$(GODOC_VER) && go install ~/go/pkg/mod/golang.org/x/tools@$(GODOC_VER)/cmd/godoc/ && $(TIDY)

docs:
	mkdir docs/lib/godoc -p
	~/go/bin/godoc -goroot $$(pwd) -url /pkg/github.com/Skenvy/Collatz/go/ > docs/index.html && sed -i '1d' docs/index.html
	cp -f ~/go/pkg/mod/golang.org/x/tools@$(GODOC_VER)/godoc/static/**.css docs/lib/godoc/
	cp -f ~/go/pkg/mod/golang.org/x/tools@$(GODOC_VER)/godoc/static/**.js docs/lib/godoc/

# Runs the ./docs/main.go from . and then targets ./docs internally
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

# locally, if test fails on the tidy, running it again shouldn't fail tidy again.
# its intent is to catch an untidy mod in CI if not run before committing.
test: clean
	[[ -z "$$($(TIDY) -v 2>&1)" ]] && echo "go.mod file is tidy" || (echo "go.mod file needs a tidy" && exit 1)
	go test -v .

build: test
	go build -o collatz ./collatz

run: build
	./collatz/collatz

publish:
	GOPROXY=proxy.golang.org go list -m github.com/Skenvy/Collatz/go@go-v$$(cat go.ver)
