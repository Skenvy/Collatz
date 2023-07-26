# Virtual Environment
VE=source .ve/bin/activate && 
.PHONY: venv clean clean_again test lint build upload_test upload
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
	$(VE) pip install --upgrade pip
	$(VE) pip install --upgrade -r requirements-venv.txt

clean clean_again:
	rm -rf src/*.egg-info/
	rm -rf dist/
	rm -rf */__pycache__/
	rm -rf */*/__pycache__/
	rm -rf .pytest_cache/
	rm  -f pylint.log
	rm  -f flake8.log

test: clean
	$(VE) pytest

# https://pylint.readthedocs.io/en/latest/user_guide/configuration/all-options.html
# https://pylint.readthedocs.io/en/latest/user_guide/messages/index.html
# https://flake8.pycqa.org/en/latest/user/configuration.html
# https://flake8.pycqa.org/en/latest/user/options.html#options-list
lint: clean
	$(VE) pylint --recursive=y --disable=C,R,I --enable=F,E,W --output-format=colorized,text:pylint.log \
	--msg-template='{C} {path}:{line}:{column}: {msg_id}: {msg} ({symbol})' src tests
	$(VE) flake8 --color=always -vv --output-file=flake8.log src tests

# build will automatically include an adjacent "LICENSE*" ~ but if it's
# referenced as ../LICENSE in either manifest or [metadate]license_files then
# it will result in being added outside the built wheel. This used to copy the
# LICENSE as `cp ../LICENSE LICENSE` -- build -- `rm LICENSE`.
build: test clean_again
	$(VE) python3 -m build
	$(VE) pip install --force-reinstall dist/*-none-any.whl

# https://twine.readthedocs.io/en/stable/#twine-upload
upload_test: build
	$(VE) twine upload --config-file ./.pypirc --repository testpypi dist/*

upload: upload_test
	$(VE) twine upload --config-file ./.pypirc --repository pypi dist/*
