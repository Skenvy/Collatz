# Devlog
[Ruby](https://www.ruby-lang.org/) and gems (packages) at [rubygems](https://rubygems.org/). For as established and wide spread a language as ruby is, especially with [Ruby on Rails](https://rubyonrails.org/), I'm surprised to see that the ruby [community](https://www.ruby-lang.org/en/community/) page includes a link to a [discord](https://discord.gg/EnSevaRfct). There's a [ruby version manager](http://rvm.io/), [guides on gem creation](https://guides.rubygems.org/), and [bundler](https://bundler.io/). We can install ruby on ubuntu with `sudo apt install ruby-full` and on windows with [rubyinstaller](https://rubyinstaller.org/), although the [documentation/installation](https://www.ruby-lang.org/en/documentation/installation/) lists a lot of other alternatives!

In terms of "trending ruby repos" on github, there's quite a few. We'll have a look through these examples;
* [ruby/ruby](https://github.com/ruby/ruby)
* [rubygems/rubygems](https://github.com/rubygems/rubygems)
* [rails/rails](https://github.com/rails/rails)
* [jekyll/jekyll](https://github.com/jekyll/jekyll)
* [dependabot/dependabot-core](https://github.com/dependabot/dependabot-core)
* [github/linguist](https://github.com/github/linguist)
* [discourse/discourse](https://github.com/discourse/discourse)
* [mastodon/mastodon](https://github.com/mastodon/mastodon)
* [sorbet/sorbet](https://github.com/sorbet/sorbet)
* [Shopify/shopify_app](https://github.com/Shopify/shopify_app)

We can follow [Make your own Gem](https://guides.rubygems.org/make-your-own-gem/). 

There are some useful looking github actions; [ruby/setup-ruby](https://github.com/marketplace/actions/setup-ruby-jruby-and-truffleruby) and [ruby/setup-ruby-pkgs](https://github.com/marketplace/actions/setup-ruby-pkgs). And also have a look at the GitHub [Working with the RubyGems registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-rubygems-registry). The github page makes mention of bundler as well, so it's worth more so having a look at [How to create a Ruby gem with Bundler](https://bundler.io/guides/creating_gem.html), which itself links to [Common practices for developing gems](https://guides.rubygems.org/patterns/). First, we'll need to install it; [`gem install bundler`](https://rubygems.org/gems/bundler). Having run it in my WSL (with sudo), it seems the same issue that happened with maven in WSL and windows has happened with `bundler`, as `which bundle` yields `/usr/local/bin/bundle`, but trying to `bundle --version` yields `/mnt/c/Ruby/3.1/bin/bundle: line 6: /mnt/c/Ruby/3.1/bin/ruby: No such file or directory`. As expected, `type bundle` comes back with `bundle is hashed (/mnt/c/Ruby/3.1/bin/bundle)`. A quick `hash -r bundle` and `bundle --version` now correctly returns `Bundler version 2.3.21`.

We should now be able to follow the [How to create a Ruby gem with Bundler](https://bundler.io/guides/creating_gem.html) page and run `bundle gem collatz`. Running it asked a bunch of questions that I wasn't necessarily ready to answer with any particular intention, so my choice of `rspec` for `bundle config gem.test` (out of `rspec/minitest/test-unit/(none)`), and `rubocop` for `bundle config gem.linter` (out of `rubocop/standard/(none)`) weren't informed, although the choice of `github` for `bundle config gem.ci` (out of `github/travis/gitlab/circle/(none)`) obviously was. Having already chosen the Apache License v2, I obviously said `n` to adding the MIT license, although selected `y` to adding a code of conduct and changelog to see what it would generate for the output of these. Running it generated all the output files in a `collatz` subdirectory from where I already was in the `~/Collatz/ruby/` folder, so I'll have to merge stuff down a folder.
