GOENV=export GOPATH=~/go && export GOBIN=~/go/bin && 
TIDY=go mod tidy
GODOC_VER=v0.1.11
PKGSITE_VER=v0.0.0-20220719173606-91f9f1ec61b0
.PHONY: godoc pkgsite docs_view clean test build run publish
SHELL:=/bin/bash

godoc:
	$(GOENV) go get golang.org/x/tools/cmd/godoc@$(GODOC_VER) && go install ~/go/pkg/mod/golang.org/x/tools@$(GODOC_VER)/cmd/godoc/ && $(TIDY)

# build golang.org/x/pkgsite/cmd/pkgsite: cannot load embed: malformed module path "embed": missing dot in first path element
# Requires go 1.16+ ~ https://pkg.go.dev/embed?tab=versions
pkgsite:
	$(GOENV) go get golang.org/x/pkgsite/cmd/pkgsite@$(PKGSITE_VER) && go install ~/go/pkg/mod/golang.org/x/pkgsite@$(PKGSITE_VER)/cmd/pkgsite/ && $(TIDY)

# Relies on but expects godoc to have been run independently as a project setup to not require its rebuilding constantly
docs:
	~/go/bin/godoc -http=127.0.0.1:6060 -goroot $$(pwd) &>/dev/null & echo $$! > KILL_PID && disown $$(cat KILL_PID)
	wget -r -np -N -E -p -k http://$$(cat /etc/resolv.conf | grep nameserver | cut -d\  -f 2):6060/pkg/github.com/Skenvy/Collatz/go/
	kill $$(cat KILL_PID) && rm KILL_PID

# http://localhost:6060/pkg/github.com/Skenvy/Collatz/go/
docs_view:
	~/go/bin/godoc -http=:6060 -goroot $$(pwd)

# Accessible at http://localhost:6060/pkg/github.com/Skenvy/Collatz/go/ ??

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
