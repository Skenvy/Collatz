# Virtual Environment -- the source activate for linux environments is supported
# but we must include qualifier to make everything "global" on windows, as the
# best way of making the github windows runner happy, which does not like really
# any method of using a venv.
#
# Trying to use """VE=.\.ve\Scripts\activate && """ results in;
# /usr/bin/sh: line 1: ..veScriptsactivate: command not found
#
# Trying to ifeq windows the shell option and force use powershell;
# ifeq ($(OS),Windows_NT)
# SHELL:=pwsh
# .SHELLFLAGS:=-NoProfile -Command
# else
# SHELL:=/bin/bash
# endif
# While also using pwsh for the windows runner;
#       matrix:
#         include:
#           - shell: bash
#           - os: windows-latest
#             shell: pwsh
# Resulted in """/usr/bin/bash: -N: invalid option""" during venv itself.
#
# So set VE and VENV to nothing when on windows.
ifeq ($(OS),Windows_NT)
# VENV=python -m venv .ve
# VE=.\.ve\Scripts\activate && 
VENV=
VE=
else
VENV=python3 -m venv .ve
VE=source .ve/bin/activate && 
endif
PIP_PIP=pip install --upgrade pip
PIP_REQ=pip install --upgrade -r
VENV_REQS=requirements-venv.txt
FROZEN_VENV_REQS=requirements-venv-frozen.txt
TEST=pytest
TOX=tox
LINT_FOLDERS=src tests .demo/_
PYLINT=pylint --recursive=y --disable=C,R,I --enable=F,E,W --output-format=colorized,text:pylint.log --msg-template='{C} {path}:{line}:{column}: {msg_id}: {msg} ({symbol})' $(LINT_FOLDERS)
FLAKE8=flake8 --color=always -vv --output-file=flake8.log $(LINT_FOLDERS)
PACKAGE_VERSION=$$(cut -d \" -f 2 src/collatz/__version__.py)
SPHINX_BUILD_SOURCE=sphinx-apidoc -Me -V $(PACKAGE_VERSION) -R $(PACKAGE_VERSION) -f -o docs/source src/
VERIFY_BUILT_MSG=echo "Exit if a change to the built Sphinx rst's is not committed"
VERIFY_BUILT_ERR=git add docs && git diff --exit-code --cached --stat -- docs/
TWINE=twine upload --config-file ./.pypirc --repository
.PHONY: venv revenv clean clean_again pydoc_server verify_built_checkin docs test tox lint build upload_test upload
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
	$(VENV)
	$(VE) $(PIP_PIP)
	$(VE) $(PIP_REQ) $(FROZEN_VENV_REQS)

revenv:
	rm -rf .ve
	$(VENV)
	$(VE) $(PIP_PIP)
	$(VE) $(PIP_REQ) $(VENV_REQS)
	$(VE) pip freeze > $(FROZEN_VENV_REQS)
	sed -i '/^pkg_resources/d' $(FROZEN_VENV_REQS)
	sed -i '/^pkg-resources/d' $(FROZEN_VENV_REQS)

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
	$(VERIFY_BUILT_MSG)
	$(VERIFY_BUILT_ERR)

# https://www.sphinx-doc.org/en/master/man/sphinx-apidoc.html
# https://www.sphinx-doc.org/en/master/man/sphinx-build.html
docs: clean
	$(VE) $(SPHINX_BUILD_SOURCE)
	$(VE) sphinx-build -a -b dirhtml -W --keep-going -n docs/source docs/build

test:
	$(VE) $(TEST)

# Pytest with tox
tox: clean
	$(VE) $(TOX)

# https://pylint.readthedocs.io/en/latest/user_guide/configuration/all-options.html
# https://pylint.readthedocs.io/en/latest/user_guide/messages/index.html
# https://flake8.pycqa.org/en/latest/user/configuration.html
# https://flake8.pycqa.org/en/latest/user/options.html#options-list
lint: clean
	$(VE) $(PYLINT)
	$(VE) $(FLAKE8)

build: test lint verify_built_checkin clean_again
	$(VE) python -m build
	$(VE) pip install --force-reinstall dist/*-none-any.whl

# https://twine.readthedocs.io/en/stable/#twine-upload
upload_test: build
	$(VE) $(TWINE) testpypi dist/*

upload: upload_test
	$(VE) $(TWINE) pypi dist/*
