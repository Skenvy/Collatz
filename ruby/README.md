# [Collatz](https://github.com/Skenvy/Collatz): [Ruby](https://github.com/Skenvy/Collatz/tree/main/ruby) 🔻💎🔻
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
gem "collatz", ">= 0.0.4
```
[Add the GitHub hosted gem](https://github.com/Skenvy/Collatz/packages/1636643);
```ruby
source "https://rubygems.pkg.github.com/skenvy" do
  gem "collatz", ">= 0.0.4"
end
```
## Usage
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same `(P,a,b)` notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to retrieve the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph. 
The only restriction placed on parameters is that both `P` and `a` can't be `0`.
## [<lang-docs-name> generated docs](https://skenvy.github.io/Collatz/ruby)
## Developing
### The first time setup
```sh
git clone https://github.com/Skenvy/Collatz.git && cd Collatz/ruby && make setup
```
### Iterative development
* <list-worthwhile-recipes>
