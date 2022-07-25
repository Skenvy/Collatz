# Collatz
Functions related to [the Collatz/Syracuse/3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture), prospectively implemented in python/R/julia/go/java/? with notes in LaTeX.
## The gist
Each language's implementation should share the same functionality, or as close to it as possible, such that a consistent usability is delivered across all languages' implementations.
For a v1.0.0 release, handling arbitrary integers is a nice to have, but not required. Alternatively, all implementations in a language might use that languages arbitrary integer implementation, as speed / performance is specifically not a focus of this, in favour of generalisability or parameterisability.
## Implementations
* [C#](#TODO)
* [Go](#TODO)
* [Java](https://search.maven.org/artifact/io.github.skenvy/collatz)
* [Julia](https://juliahub.com/ui/Packages/Collatz/UmeZE)
* [LaTeX](#TODO)
* [Node.JS](#TODO)
* [python](https://pypi.org/project/collatz/)
* [R](#TODO)
* [Ruby](#TODO)
## Basic functionality.
### Core functionality for v1
* The **function**, _optionally_ parameterisable.
* The **reverse function**, _optionally_ parameterisable.
* Obtaining a **hailstone sequence**, with _optional_ max stopping time, parameterisability, "stopping mode" (_total stop_ or _stop_), and inclusion of verbose control sequence flags to describe the output.
* The **stopping time**, with _optional_ max stopping time, parameterisability, "stopping mode" (_total stop_ or _stop_).
* The **tree graph** _hailstone equivalent_ using the reverse function, with _optional_ parameterisability, and **not optional** "maximum orbit".
