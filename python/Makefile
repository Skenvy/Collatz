# Virtual Environment
VE=source .ve/bin/activate && 
SPHINX_BUILD_SOURCE=sphinx-apidoc -o docs/source src/
TWINE=twine upload --config-file ./.pypirc --repository
.PHONY: venv clean clean_again pydoc_server verify_built_checkin docs test lint build upload_test upload
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
	rm -rf docs/build/

# http://localhost:44449/
# http://localhost:44449/src.collatz.html
pydoc_server:
	$(VE) python -m pydoc -b

verify_built_checkin: clean
	$(VE) $(SPHINX_BUILD_SOURCE)
	echo "Exit if a change to the built Sphinx rst's is not committed"
	git add docs && git diff --exit-code --cached --stat -- docs/

docs: clean
	$(SPHINX_BUILD_SOURCE)
	sphinx-build docs/source docs/build

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

build: test lint verify_built_checkin clean_again
	$(VE) python -m build
	$(VE) pip install --force-reinstall dist/*-none-any.whl

# https://twine.readthedocs.io/en/stable/#twine-upload
upload_test: build
	$(VE) $(TWINE) testpypi dist/*

upload: upload_test
	$(VE) $(TWINE) pypi dist/*
