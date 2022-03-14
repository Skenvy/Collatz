# Virtual Environment
VE=source .ve/bin/activate && 

.PHONY: venv clean build test upload_test upload
SHELL:=/bin/bash

venv:
	python3 -m venv .ve
	$(VE) pip install --upgrade pip && \
	pip install --upgrade "build>=0.7.0,<1" twine pytest==7.1.0

clean:
	rm -rf src/*.egg-info/
	rm -rf dist/
	rm -rf src/*/__pycache__/

build: clean
	$(VE) python3 -m build && \
	$(VE) pip install --upgrade dist/*-none-any.whl

test:
	$(VE) pytest

# https://twine.readthedocs.io/en/stable/#twine-upload
upload_test:
	$(VE) twine upload --config-file ./.pypirc --repository testpypi dist/*

upload:
	$(VE) twine upload --config-file ./.pypirc --repository pypi dist/*
