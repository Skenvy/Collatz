# [Collatz](https://github.com/Skenvy/Collatz): [JavaScript](https://github.com/Skenvy/Collatz/tree/main/javascript) 🟨🟦🟩🟥
<p align="center"><img alt="Banner Image, Collatz Coral" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/_JavaScript.png" width=830 height=666/></p>
<sub><p align="center"><i>
  <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/README.md">Colourised Collatz Coral</a>; derived from this
  <a href="https://twitter.com/Gelada/status/846751901756653568">original by Edmund Harriss</a>
</i></p></sub>

---
Functions related to [the Collatz/Syracuse/3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture), implemented in [JavaScript](https://tc39.es/ecma262/) (transpiled from [TypeScript](https://www.typescriptlang.org/)).
## Getting Started
[To install the latest from npm](https://www.npmjs.com/package/@skenvy/collatz);
```sh
npm i @skenvy/collatz
```
Also available on [deno](https://deno.land/x/collatz) and on [jsr](https://jsr.io/@skenvy/collatz).
## Usage
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same `(P,a,b)` notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to retrieve the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph. 
The only restriction placed on parameters is that both `P` and `a` can't be `0`.
## [Usage Examples]()
## [TSDoc+TypeDoc generated docs](https://skenvy.github.io/Collatz/javascript)
## [Istanbul.js/nyc generated coverage](https://skenvy.github.io/Collatz/javascript/coverage)
## Developing
### The first time setup
```sh
git clone https://github.com/Skenvy/Collatz.git && cd Collatz/javascript && make setup
```
### Iterative development
The majority of `make` recipes for this are just wrapping an invocation of `npm run ...` on one of the `package.json`'s `"scripts"`.
If you want to run these with a version of node installed outside of `nvm` and you're sure you've got the right `node` and `npm` versions, you can append `_=""` to your `make` invocations to circumvent `nvm` proctoring.
* `make docs` will recreate the [TypeDoc](https://typedoc.org/) docs, based on [TSDoc](https://tsdoc.org/) comments.
* `make test` will run the [mocha](https://mochajs.org/) tests and attempt a dry run of the publishing.
* `make lint` will run [eslint](https://eslint.org/).
* `make verify_transpiled_checkin` will confirm you haven't forgotten to check in changes to the transpiled output.
* `make build` will run `npm pack` after linting, testing, and verifying check-in.
## [Open Source Insights](https://deps.dev/npm/%40skenvy%2Fcollatz)
