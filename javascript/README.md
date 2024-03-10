# [Collatz](https://github.com/Skenvy/Collatz): [JavaScript](https://github.com/Skenvy/Collatz/tree/main/javascript) 🟨🟦🟩🟥
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/_transform.png">
  <img alt="Text changing depending on mode. Light: 'So light!' Dark: 'So dark!'" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/_transform.png" width=830 height=666>
</picture>

Functions related to [the Collatz/Syracuse/3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture), implemented in [JavaScript](https://tc39.es/ecma262/) (transpiled from [TypeScript](https://www.typescriptlang.org/)).
## Getting Started
[To install the latest from npm](https://www.npmjs.com/package/@skenvy/collatz);
```sh
npm i @skenvy/collatz
```
[Also available on deno](https://deno.land/x/collatz). See the [typescript import](https://deno.land/x/collatz/src/index.ts), the [CommonJS import](https://deno.land/x/collatz/lib/cjs/index.js), or the [ECMAScript import](https://deno.land/x/collatz/lib/esm/index.mjs).
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
git clone https://github.com/Skenvy/Collatz.git && cd Collatz/javascript && make install_npm && make setup
```
### Iterative development
The majority of `make` recipes for this are just wrapping an invocation of `npm run ...` on one of the `package.json`'s `"scripts"`.
* `make docs` will recreate the [TypeDoc](https://typedoc.org/) docs, based on [TSDoc](https://tsdoc.org/) comments.
* `make test` will run the [mocha](https://mochajs.org/) tests and attempt a dry run of the publishing.
* `make lint` will run [eslint](https://eslint.org/).
* `make verify_transpiled_checkin` will confirm you haven't forgotten to check in changes to the transpiled output.
* `make build` will run `npm pack` after linting, testing, and verifying check-in.
## [Open Source Insights](https://deps.dev/npm/%40skenvy%2Fcollatz)
