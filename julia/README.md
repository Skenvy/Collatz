# [Collatz](https://github.com/Skenvy/Collatz): [Julia](https://github.com/Skenvy/Collatz/tree/main/julia) 🔴🟢🟣
<p align="center"><img alt="Banner Image, Collatz Coral" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/_Julia.png" width=830 height=666/></p>
<sub><p align="center"><i>
  <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/README.md">Colourised Collatz Coral</a>; derived from this
  <a href="https://twitter.com/Gelada/status/846751901756653568">original by Edmund Harriss</a>
</i></p></sub>

---
Functions related to [the Collatz/Syracuse/3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture), implemented in [Julia](https://julialang.org/).
## Getting Started
[To install the latest from JuliaRegistries/General](https://github.com/JuliaRegistries/General/tree/master/C/Collatz) ([also see JuliaHub](https://juliahub.com/ui/Packages/Collatz/UmeZE));
### From anywhere, in REPL
```julia
julia> using Pkg; Pkg.add("Collatz")
```
### _Or_ add it to a Project.tml
```sh
julia --project=. -e "using Pkg; Pkg.add(\"Collatz\")"
```
## Usage
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same `(P,a,b)` notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to retrieve the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph. 
The only restriction placed on parameters is that both `P` and `a` can't be `0`.
## [Documenter.jl generated docs](https://skenvy.github.io/Collatz/julia). 
## Developing
### The first time setup
```
git clone https://github.com/Skenvy/Collatz.git && cd Collatz/julia && make deps
```
### Iterative development
* `make build` will run both `make test` (the unit tests) and `make docs`.
* `make test` precompiles and runs the unit tests.
* `make docs` runs the strict doctesting makedocs.
* `make docs_view` will `make docs` and start [LiveServer](https://github.com/tlienart/LiveServer.jl) on them.
* `make repl` will reinitialise the package and initiate the repl with `using Collatz`
