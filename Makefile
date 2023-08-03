jekyll=bundle exec jekyll
.PHONY: setup clean test build serve
SHELL:=/bin/bash

# Assumes `gem install bundler`
setup:
	bundle install

update:
	bundle update

clean:
	$(jekyll) clean

test:
	$(jekyll) doctor

nojekyll:
	find $$(find . -name '\.nojekyll' -exec dirname "{}" \;) -type f -exec \
	yq eval '.include += ["{}"]' -i ./_config.yml \;

build:
	$(jekyll) build --config ./_config.yml --future --trace

# http://localhost:4000/Collatz/
serve:
	$(jekyll) serve --port 4000 --open-url
