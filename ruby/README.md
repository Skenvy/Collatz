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
gem "collatz", ">= 1.0.0
```
[Add the GitHub hosted gem](https://github.com/Skenvy/Collatz/packages/1636643);
```ruby
source "https://rubygems.pkg.github.com/skenvy" do
  gem "collatz", ">= 1.0.0"
end
```
## Usage
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same `(P,a,b)` notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to retrieve the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph. 
The only restriction placed on parameters is that both `P` and `a` can't be `0`.
## [RDoc generated docs](https://skenvy.github.io/Collatz/ruby)
## Developing
You will need to install [rvm](https://rvm.io/) and one of its [ruby binaries](https://rvm.io/binaries/).

You'll also need to set the `RVM_DIR` in your shell profile e.g. [like this](https://github.com/Skenvy/dotfiles/blob/1de61272c588a30b634a03a7d304ef51e40c72f1/.bash_login#L17). RVM will set some basic initialisation in your shell profile, but changing what it sets to instead use `RVM_DIR` like this allows you to install it somewhere other than the default.

The `make initialise` in [first time setup](#the-first-time-setup) will install the intended development version for you, but it might not be a precompiled binary, depending on your OS and architecture ~ if it isn't precompiled, contributing your time in compiling to [publish the binary for rvm](https://github.com/rvm/rvm/issues/4921) is probably more worth your time than this lol.

RVM is locally how we manage proctoring the ruby environment. It is not on the [github runners](https://github.com/actions/runner-images), so the make invocations in the workflows set the RVM proctors empty.
### The first time setup
```sh
git clone https://github.com/Skenvy/Collatz.git && cd Collatz/ruby && make setup
```
### Iterative development
The majority of `make` recipes for this are just wrapping a `bundle` invocation of `rake`.
* `make docs` will recreate the RDoc docs
* `make test` will run the RSpec tests.
* `make lint` will run the RuboCop linter.
