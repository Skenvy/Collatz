# Virtual Environment
VE=source .ve/bin/activate && 
# Test Virtual Environment
TVE=source .tve/bin/activate && 

.PHONY: venv build clean upload
SHELL:=/bin/bash

venv:
	python3 -m venv .ve
	$(VE) pip install --upgrade pip && \
	pip install --upgrade "build>=0.7.0,<1" twine

clean:
	rm -rf src/*.egg-info/
	rm -rf dist/
	rm -rf .tve/
	rm -rf src/*/__pycache__/

build: clean
	$(VE) python3 -m build && \
	python3 -m venv .tve && \
	$(TVE) pip install dist/*-none-any.whl && \
	echo "RUN: $(TVE)"

# https://twine.readthedocs.io/en/stable/#twine-upload
upload_test:
	$(VE) twine upload --config-file ./.pypirc --repository testpypi dist/*

upload:
	$(VE) twine upload --config-file ./.pypirc --repository pypi dist/*
