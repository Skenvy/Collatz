# [Collatz](https://github.com/Skenvy/Collatz): [Ruby](https://github.com/Skenvy/Collatz/tree/main/ruby) 🔻💎🔻
<p align="center"><img alt="Banner Image, Collatz Coral" src="https://raw.githubusercontent.com/wiki/Skenvy/Collatz/.meta/banners/modifications/_Ruby.png" width=830 height=666/></p>
<sub><p align="center"><i>
  <a href="https://github.com/Skenvy/Collatz/blob/main/.meta/banners/README.md">Colourised Collatz Coral</a>; derived from this
  <a href="https://twitter.com/Gelada/status/846751901756653568">original by Edmund Harriss</a>
</i></p></sub>

---
Functions related to [the Collatz/Syracuse/3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture), implemented in [Ruby](https://www.ruby-lang.org/).
## Getting Started
[To install the latest from RubyGems](https://rubygems.org/gems/collatz);
```sh
gem install collatz
```
[Or to install from GitHub's hosted gems](https://github.com/Skenvy/Collatz/packages/1636643);
```sh
gem install collatz --source "https://rubygems.pkg.github.com/skenvy"
```
### Add to the Gemfile
[Add the RubyGems hosted gem](https://rubygems.org/gems/collatz);
```ruby
gem "collatz", ">= 0.1.0
```
[Add the GitHub hosted gem](https://github.com/Skenvy/Collatz/packages/1636643);
```ruby
source "https://rubygems.pkg.github.com/skenvy" do
  gem "collatz", ">= 0.1.0"
end
```
## Usage
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same `(P,a,b)` notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to retrieve the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph. 
The only restriction placed on parameters is that both `P` and `a` can't be `0`.
## [RDoc generated docs](https://skenvy.github.io/Collatz/ruby)
## Developing
### The first time setup
```sh
git clone https://github.com/Skenvy/Collatz.git && cd Collatz/ruby && make setup
```
### Iterative development
The majority of `make` recipes for this are just wrapping a `bundle` invocation of `rake`.
* `make docs` will recreate the RDoc docs
* `make test` will run both the RSpec tests and the RuboCop linter.
