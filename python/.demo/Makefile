VE=source .ve/bin/activate && 
.PHONY: install demo everything
SHELL:=/bin/bash

install:
	python3 -m venv .ve
	$(VE) pip install --upgrade pip
	$(VE) pip install --upgrade collatz-*-none-any.whl

demo:
	$(VE) find ./_/*.py -maxdepth 1 -type f | xargs -L1 python

everything: install demo
