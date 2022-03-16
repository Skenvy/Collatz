# Virtual Environment
VE=source .ve/bin/activate && 
WVE=.\.ve\Scripts\Activate.ps1 && 
.PHONY: venv clean build test upload_test upload
SHELL:=/bin/bash

# https://code.visualstudio.com/docs/python/environments
# https://docs.python.org/3/library/venv.html < for pwsh execution policy.
# Will need to `python -m venv .ve` from pwsh separately to create the
# ~/.ve/Scripts/python.exe if this Makefile is run from WSL, which doesn't
# populate the ~/.ve/Scripts folder, but is needed to run the venv as the
# interpreter by an IDE on windows. Make sure to create it at a different
# place to the .ve in ~/python/ as the venv is mutually exclusive between them.
# Despite being in a venv pip install --upgrade pip still needs admin on windows
venv:
	python3 -m venv .ve
	$(VE) pip install --upgrade pip && \
	pip install --upgrade "build>=0.7.0,<1" twine pytest==7.1.0

clean:
	rm -rf src/*.egg-info/
	rm -rf dist/
	rm -rf src/*/__pycache__/

build: clean
	$(VE) python3 -m build
	$(VE) pip install --upgrade dist/*-none-any.whl

test:
	$(VE) pytest

# https://twine.readthedocs.io/en/stable/#twine-upload
upload_test:
	$(VE) twine upload --config-file ./.pypirc --repository testpypi dist/*

upload:
	$(VE) twine upload --config-file ./.pypirc --repository pypi dist/*
