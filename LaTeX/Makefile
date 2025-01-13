.PHONY: clean pdf
SHELL:=/bin/bash

clean:
	rm -f *.aux
	rm -f *.log
	rm -f *.toc
	rm -f *.pdf

.DEFAULT_GOAL :=
pdf: clean
	pdflatex document.tex
