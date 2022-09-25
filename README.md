# Collatz
Functions related to [the Collatz/Syracuse/3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture), prospectively implemented in python/R/julia/go/java/? with notes in LaTeX.
## Badges
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/6311/badge)](https://bestpractices.coreinfrastructure.org/projects/6311) [![Go Reference](https://pkg.go.dev/badge/github.com/Skenvy/Collatz/go.svg)](https://pkg.go.dev/github.com/Skenvy/Collatz/go) [![CRAN Version](https://www.r-pkg.org/badges/version/collatz)](https://cran.r-project.org/package=collatz)
## The gist
Each language's implementation should share the same functionality, or as close to it as possible, such that a consistent usability is delivered across all languages' implementations.
For a v1.0.0 release, handling arbitrary integers is a nice to have, but not required. Alternatively, all implementations in a language might use that languages arbitrary integer implementation, as speed / performance is specifically not a focus of this, in favour of generalisability or parameterisability.
## Implementations
| Code | External Pkg | GitHub Pages | Internal Pkg |
| :--- | :---         | :---         | :---         |
| [C#](https://github.com/Skenvy/Collatz/tree/main/C%23) | **#TODO** | **#TODO** | **#TODO** |
| [Go](https://github.com/Skenvy/Collatz/tree/main/go) | [pkg.go.dev](https://pkg.go.dev/github.com/Skenvy/Collatz/go) | [GoDoc](https://skenvy.github.io/Collatz/go/)+[Cover](https://skenvy.github.io/Collatz/go/coverage.html) | _N/A_ |
| [Java](https://github.com/Skenvy/Collatz/tree/main/java) | [mvn-central](https://search.maven.org/artifact/io.github.skenvy/collatz) | [Site](https://skenvy.github.io/Collatz/java/)+[JavaDoc](https://skenvy.github.io/Collatz/java/apidocs/io/github/skenvy/package-summary.html) | [mvn-gh](https://github.com/Skenvy/Collatz/packages/1445255) |
| [Julia](https://github.com/Skenvy/Collatz/tree/main/julia) | [juliahub](https://juliahub.com/ui/Packages/Collatz/UmeZE) | [Documenter](https://skenvy.github.io/Collatz/julia/) | _N/A_ |
| [LaTeX](https://github.com/Skenvy/Collatz/tree/main/LaTeX) | _N/A_ | **#TODO** | _N/A_ |
| [Node.JS](https://github.com/Skenvy/Collatz/tree/main/node.js) | **#TODO** | **#TODO** | **#TODO** |
| [Python](https://github.com/Skenvy/Collatz/tree/main/python) | [pypi](https://pypi.org/project/collatz/) | **#TODO** | _N/A_ |
| [R](https://github.com/Skenvy/Collatz/tree/main/R) | [CRAN](https://cran.r-project.org/package=collatz) | [roxy+pkgd](https://skenvy.github.io/Collatz/R/)+[covr](https://skenvy.github.io/Collatz/R/covr/Collatz-report.html)+[PDF](https://skenvy.github.io/Collatz/R/pdf/) | _N/A_ |
| [Ruby](https://github.com/Skenvy/Collatz/tree/main/ruby) | [RubyGems](https://rubygems.org/gems/collatz) | [RDoc](https://skenvy.github.io/Collatz/ruby/) | [gems-gh](https://github.com/Skenvy/Collatz/packages/1636643) |
| [Rust](https://github.com/Skenvy/Collatz/tree/main/rust) | **#TODO** | **#TODO** | **#TODO** |
## Basic functionality.
### Core functionality for v1
* The **function**, _optionally_ parameterisable.
* The **reverse function**, _optionally_ parameterisable.
* Obtaining a **hailstone sequence**, with _optional_ max stopping time, parameterisability, "stopping mode" (_total stop_ or _stop_), and inclusion of verbose control sequence flags to describe the output.
* The **stopping time**, with _optional_ max stopping time, parameterisability, "stopping mode" (_total stop_ or _stop_).
* The **tree graph** _hailstone equivalent_ using the reverse function, with _optional_ parameterisability, and **not optional** "maximum orbit".
