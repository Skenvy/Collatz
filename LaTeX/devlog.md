# Devlog
The current `document.tex` is a series of commits replayed from the original "collatz" repo I made before this one, when I was initially writing my poorly organised notes into LaTeX.

To enable building the pdf on ubuntu, we need;
```bash
sudo apt-get install texlive-latex-base
```
This is all we _need_ to `make pdf` and get the generated pdf, but it's worth knowing that searching around for how to build pdf's, sites often also cite `texlive-latex-recommended` and `texlive-latex-extra` as suggested for install alongside `texlive-latex-base` but they amount to several additional GB of space, so I'd like to avoid them until necessary.
