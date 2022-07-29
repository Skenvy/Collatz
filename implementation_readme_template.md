# A template for each implementation's readme
Any section can be reasonably extended with more example, but this represents the prefered minimum. Can be search+replace'd on:
* `<Language>` (case dependent)
* `<language>` (case dependent)
* `<language-emojis>`
* `<language-website>`
* `<package-site-name>`
* `<package-website>` (targetting the actual package uploaded, not just the generic website)
* `<installion-command>` (install with the package manager)
* `<lang-docs-name>` (the _name_ of the tool used to generate docs)
* `<localised-setup-command>` (The first time setup)
* `<list-worthwhile-recipes>` (Iterative development)
* `<deps-dev-link>` (link on [deps.dev](https://deps.dev/)) -- which is not relevant to all languages
````md
# [Collatz](https://github.com/Skenvy/Collatz): [<Language>](https://github.com/Skenvy/Collatz/tree/main/<language>) <language-emojis>
Functions related to [the Collatz/Syracuse/3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture), implemented in [<Language>](<language-website>).
## Getting Started
[To install the latest from <package-site-name>](<package-website-specific>);
```sh
<installion-command>
```
## Usage
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same `(P,a,b)` notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to retrieve the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph. 
The only restriction placed on parameters is that both `P` and `a` can't be `0`.
## [<lang-docs-name> generated docs](https://skenvy.github.io/Collatz/<language>)
## Developing
### The first time setup
```sh
git clone https://github.com/Skenvy/Collatz.git && cd Collatz/<language> && <localised-setup-command>
```
### Iterative development
*<list-worthwhile-recipes>
## [Open Source Insights](<deps-dev-link>)
````