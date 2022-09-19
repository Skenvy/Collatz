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

In terms of what it added, post merging down a folder, besides all the other decorating files, we have (besides the README instructions);
* `~/.rspec` (RSpec testing)
* `~/.rubocop.yml` (RuboCop linter)
* `~/collatz.gemspec` (description file of the gem)
* `~/Gemfile` (Bundler declarative dependencies)
* `~/Gemfile.lock` (Bundler imperative dependencies)
* `~/Rakefile` (Ruby's official task running makefile)
* `~/bin/console` (Bundler script)
* `~/bin/setup` (Bundler script)
* `~/lib/collatz.rb` (what is loaded from a `require "collatz"` invocation)
* `~/lib/collatz/version.rb` (project's version as an object instance _in-code_)
* `~/sig/collatz.rbs` (Signature)
* `~/spec/collatz_spec.rb` (RSpec testing)
* `~/spec/spec_helper.rb` (RSpec testing)

From the [Make your own Gem](https://guides.rubygems.org/make-your-own-gem/) guide, we can see that the `~/collatz.gemspec` (description file of the gem) and `~/lib/collatz.rb` (what is loaded from a `require "collatz"` invocation) are the most fundamental pieces of the package. Anything else under `~/lib/` is just the normal code of the package, and it seems `~/lib/collatz/version.rb` is just a convenient way of only writing it in one place, similar to the python version file. The `~/Rakefile` is a "Ruby Makefile" to run [`rake`](https://github.com/ruby/rake) commands, with `rake` being a general task runner for Ruby. The [`~/Gemfile`](https://bundler.io/man/gemfile.5.html) is a bundler file for listing the declarative dependencies, mostly in the form of required gems. The `~/Gemfile.lock` is an imperative stateful instantiation of the [`~/Gemfile`](https://bundler.io/man/gemfile.5.html).

Both files in the `~/spec/` folder and the `~/.rspec` file are RSpec testing files, which was what we chose in `bundle config gem.test` (out of `rspec/minitest/test-unit/(none)`) where `minitest` is the ruby default OotB testing framework. From looking at the examples on the guide using minitest versus what bundler generated for the choice of rspec, it seems that the choice impacts what is required in the rakefile, how it sets up the "test task" and how it knows where to look for the files to interpret under which ever testing framework was chosen. I'm not immediately a huge fan of the "acceptance testing" style of the rspec testing over the "expect"-esque style of the minitest framework, so I might swap to that later. Both `~/bin/` files are ignored by the `~/collatz.gemspec` dynamic determination of the `spec.files` field. The guide for creating a gem mentions bin files being included, so it seems the bundler default is to ignore the potential of wanting to add a binary file over what it considers the most beneficial way of setting itself up with the bin scripts. I'm not sure how easily they could be removed, i.e. how that would break bundler commands, but I imagine there'd be no way to keep them if wanting to remove the bin exclusion from the `spec.files` to actually include an executable with the gem.

The `~/.rubocop.yml` is a config for the `rubocop` choice we made for `bundle config gem.linter` (out of `rubocop/standard/(none)`), and there is an entry for a task in the rakefile to run this linter. I'm not sure yet what requires or expects the `~/sig/collatz.rbs` file, but its [`rbs`](https://github.com/ruby/rbs) extension is ruby official. Asking the ruby discord reveals that it's a pretty new feature and entirely optional. Although signature / type interfacing has been provided by gems like sorbet for a long time, the ruby official rbs itself is new.

Now that we have a small understanding of what is going on with the files, let's try and set up a "Hello World" package with v0.0.1 to release to GitHub packages to get that part of the workflow set up. After trying to run `bundle exec rake` a few times to test the output and verify that it works, I've realised how grossly verbose RuboCop is, and it might be worthwhile switching to standard instead. As much as I don't like [Black](https://black.readthedocs.io/en/stable/) (the python strict linter), I wonder if [standard](https://github.com/testdouble/standard), which is also strict, would be passable. Well, either way, I had to explicitly disable the `Lint/ScriptPermission` cop, as it was not recommended as a missing cop locally or in github, but was still causing the workflow to fail with `bin/console:1:1: w: lint/scriptpermission: script file console doesn't have execute permission.`, which was _NOT_ fixed by following [this rubocop issue](https://github.com/rubocop/rubocop/issues/4526). We've got to manually add the `spec.license = "Apache-2.0"` in the gempsec.

[Publishing your gem](https://guides.rubygems.org/publishing/) makes mention of "PUBLISHING TO RUBYGEMS.ORG" which includes signing up at [rubygems](https://rubygems.org/users/new), then running `gem push <pkgame-version.gem>`, which will generate a `~/.gem/credentials` the first time it's run after asking for your credentials that were used to sign up. As we obviously can't commit that sort of file, we'll need to run [`gem signin`](https://guides.rubygems.org/command-reference/#gem-signin) to get the right credentials file. If you're like me and using an older version of ruby, then an email to your account may prompt you to run `gem update --system`, but it's also then worth visiting [profile/api_keys](https://rubygems.org/profile/api_keys) to restrict the scopes of the key that's just been generated. The contents of the `~/.gem/credentials` file look like;
```yaml
---
:rubygems_api_key: rubygems_0123456789abcdef0123456789abcdef0123456789abcdef
```
While the [GitHub: Working with the RubyGems registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-rubygems-registry) guide includes mention of the expecation for the file to look like;
```yaml
---
:github: Bearer <PAT|TOKEN>
```
We can `base64 ~/.gem/credentials` the rubygems_api_key we got from the `gem signin`, add the string (without the newlines) to our github secrets, and then do something like `echo -n "$RUBYGEMS_API_KEY_BASE64" | base64 --decode > ~/.gem/credentials` to recreate the credentials. GitHub's credentials should be passable with a `echo -e "---\n:github: Bearer <PAT|TOKEN>" > ~/.gem/credentials`.

With that now merged we can work on adding the functionality and setting up documentation. The two main choices for documentation generation appear to be [rdoc](https://github.com/ruby/rdoc) or [yard](https://yardoc.org/). Yard looks alright, but we're trying to stick to any "official" way of doing something, and with rdoc being put out by ruby, we'll start off with rdoc. We can [`bundle add rdoc --version "~> 6.0" --verbose`](https://bundler.io/man/bundle-add.1.html), but doing this just leads to it permanently hanging on a ""HTTP GET https://index.rubygems.org/versions" immediately after a "HTTP 416 Range Not Satisfiable https://index.rubygems.org/versions". There's quite a few hits for this or similar issues cropping up, but none with a definitive answer or cause, and none that worked to fix the issue here. It took a 20 minute wait for it to finally do anything, then kept asking for my sudo password and refusing to accept it. I retried and it succeeded much quicker, although still took 4 entries of my password to get it to successfully pass and hit that "Bundle complete! 5 Gemfile dependencies, 23 gems now installed". Following the [rdoc](https://github.com/ruby/rdoc) guide to add rdoc to the rakefile leads to a ``rake aborted! NoMethodError: undefined method `delete_if' for nil:NilClass`` which could be connected to [this issue](https://github.com/ruby/rdoc/issues/352), namely ["You haven't told RDoc to document any files"](https://github.com/ruby/rdoc/issues/352#issuecomment-110185993). We can avoid this issue if we use the [rdoc task](https://ruby.github.io/rdoc/RDocTask.html) instead. As we start to add the first few lines to the main rb file, we've run into yet another rubocop yelling about something inconsequential (Style/NumericLiterals isn't even listed in our rubocop yaml, so we'll have to add it to disable it);
```
lib/collatz.rb:19:20: C: [Correctable] Style/NumericLiterals: Use underscores(_) as thousands separator and separate every 3 digits with them.
VERIFIED_MAXIMUM = 295147905179352825856
                   ^^^^^^^^^^^^^^^^^^^^^
```
We'll also have to add the cop `Naming/MethodParameterName: MinNameLength: 1` to stop it from complaining about all our uses of `"P"`, `"a"`, and `"b"`. Also worth mentioning is that, unlike other implementations, in ruby we can't use a capital letter to start a non-constant value, so we have to swap all capital `"P"` for lowercase `"p"`'s, lest we get the `"Formal argument cannot be a constant"` error.
