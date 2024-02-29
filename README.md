# [Collatz](https://github.com/Skenvy/Collatz)
Of all the [open problems in mathematics](https://en.wikipedia.org/wiki/List_of_unsolved_problems_in_mathematics), the [Collatz Conjecture / 3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture) [[*](https://mathworld.wolfram.com/CollatzProblem.html)] is infamously probably the most disproportionately difficult to solve compared to how incredibly simple it is to state.
The simplest form of the question is, for every positive integer, if we recursively halve any even integer, and alternatively multiply by 3 and add 1 for any odd integer, are we guaranteed to eventually end up with a value of 1.

This project aims to provide as similar an interface and experience as possible, across several languages, for interacting with basic functionality related to the Collatz conjecture.
The initial focus is a breadth first approach, that tries to provide a parameterisable hailstone and tree-graphing function in every implementation that has been committed to.
After these are complete, the focus will shift to providing LaTeX notes on particular approaches to solving it, which have the potential to inform what additional features and functionality will likely be added.
[Although you can always raise a feature request](https://github.com/Skenvy/Collatz/issues/new?assignees=&labels=enhancement&projects=&template=feature-request.yaml), there's no guarantee as to how it will be prioritised.

The list of implementations, where the externally hosted package lives, where the GitHub hosted pages lives, and whether there is an internal package hosted on GitHub or not, are listed below.
## Badges
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/6311/badge)](https://bestpractices.coreinfrastructure.org/projects/6311)
[![Go Reference](https://pkg.go.dev/badge/github.com/Skenvy/Collatz/go.svg)](https://pkg.go.dev/github.com/Skenvy/Collatz/go)
[![Go Report Card](https://goreportcard.com/badge/github.com/Skenvy/Collatz/go)](https://goreportcard.com/report/github.com/Skenvy/Collatz/go)
[![CRAN Version](https://www.r-pkg.org/badges/version/collatz)](https://cran.r-project.org/package=collatz)
## Implementations
| Code | External Pkg | GitHub Pages | Internal Pkg |
| :--- | :---         | :---         | :---         |
| [C#](https://github.com/Skenvy/Collatz/tree/main/C%23) | **#TODO** | **#TODO** | **#TODO** |
| [Go](https://github.com/Skenvy/Collatz/tree/main/go) | [pkg.go.dev](https://pkg.go.dev/github.com/Skenvy/Collatz/go) | [GoDoc](https://skenvy.github.io/Collatz/go/)+[Cover](https://skenvy.github.io/Collatz/go/coverage.html) | _N/A_ |
| [Java](https://github.com/Skenvy/Collatz/tree/main/java) | [mvn-central](https://search.maven.org/artifact/io.github.skenvy/collatz) | [Site](https://skenvy.github.io/Collatz/java/)+[JavaDoc](https://skenvy.github.io/Collatz/java/apidocs/io/github/skenvy/package-summary.html) | [mvn-gh](https://github.com/Skenvy/Collatz/packages/1445255) |
| [JavaScript](https://github.com/Skenvy/Collatz/tree/main/javascript) | [npm](https://www.npmjs.com/package/@skenvy/collatz) | [TSDoc+TypeDoc](https://skenvy.github.io/Collatz/javascript) | [npm-gh](https://github.com/Skenvy/Collatz/pkgs/npm/collatz) |
| [Julia](https://github.com/Skenvy/Collatz/tree/main/julia) | [juliahub](https://juliahub.com/ui/Packages/Collatz/UmeZE) | [Documenter](https://skenvy.github.io/Collatz/julia/) | _N/A_ |
| [LaTeX](https://github.com/Skenvy/Collatz/tree/main/LaTeX) | _N/A_ | **#TODO** | _N/A_ |
| [Python](https://github.com/Skenvy/Collatz/tree/main/python) | [pypi](https://pypi.org/project/collatz/) | [Sphinx+MyST](https://skenvy.github.io/Collatz/python/) | _N/A_ |
| [R](https://github.com/Skenvy/Collatz/tree/main/R) | [CRAN](https://cran.r-project.org/package=collatz) | [roxy+pkgd](https://skenvy.github.io/Collatz/R/)+[covr](https://skenvy.github.io/Collatz/R/covr/Collatz-report.html)+[PDF](https://skenvy.github.io/Collatz/R/pdf/) | _N/A_ |
| [Ruby](https://github.com/Skenvy/Collatz/tree/main/ruby) | [RubyGems](https://rubygems.org/gems/collatz) | [RDoc](https://skenvy.github.io/Collatz/ruby/) | [gems-gh](https://github.com/Skenvy/Collatz/packages/1636643) |
| [Rust](https://github.com/Skenvy/Collatz/tree/main/rust) | **#TODO** | **#TODO** | _N/A_ |
## Versioned Functionality
* "_optionally_" refers to the ability to provide parameterisation at will, i.e. you should be able to choose to provide it or not to. It does not mean that the parameterisability as a feature is optional to implement.
### V0: Basic: Function and Reverse Function
* The **function**, _optionally_ parameterisable.
* The **reverse function**, _optionally_ parameterisable.
### V1: Core: Hailstone and Treegraph, parameterisable and accepting arbitrary integers.
* The **function**, _optionally_ parameterisable, accepts arbitrary integers.
* The **reverse function**, _optionally_ parameterisable, accepts arbitrary integers.
* **Hailstone sequences**, with _optional_ max stopping time, parameterisability, "stopping mode" (_total stop_ or _stop_), and inclusion of verbose control sequence flags to describe the output.
* **Stopping time**, with _optional_ max stopping time, parameterisability, "stopping mode" (_total stop_ or _stop_).
* **Tree graphs** (_hailstone equivalent_ using the reverse function), with _optional_ parameterisability, and **not optional** "maximum orbit".
### V2:?
