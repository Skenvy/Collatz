.PHONY: clean pdf
SHELL:=/bin/bash

clean:
	rm *.aux
	rm *.log
	rm *.toc
	rm *.pdf

.DEFAULT_GOAL :=
pdf: clean
	pdflatex document.tex
