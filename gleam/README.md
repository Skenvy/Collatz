# [Collatz](https://github.com/Skenvy/Collatz): [Gleam](https://github.com/Skenvy/Collatz/tree/main/gleam) 🩷⭐🩷
<p align="center"><img alt="Banner Image, Collatz Coral" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/XYZ.png" width=830 height=666/></p>
<sub><p align="center"><i>
  <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/README.md">Colourised Collatz Coral</a>; derived from this
  <a href="https://twitter.com/Gelada/status/846751901756653568">original by Edmund Harriss</a>
</i></p></sub>

---
Functions related to [the Collatz/Syracuse/3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture), implemented in [Gleam](https://gleam.run/).
## Pre development notes.
## Getting Started
[To install the latest from Hex](https://hex.pm/packages?search=collatz) ([or as it appears on gleam packages](https://packages.gleam.run/?search=collatz));
```sh
<installion-command>
```
## Usage
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same `(P,a,b)` notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to retrieve the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph. 
The only restriction placed on parameters is that both `P` and `a` can't be `0`.
## [<lang-docs-name> generated docs](https://skenvy.github.io/Collatz/gleam)
## Developing
### The first time setup
```sh
git clone https://github.com/Skenvy/Collatz.git && cd Collatz/gleam && <localised-setup-command>
```
### Iterative development
*<list-worthwhile-recipes>
