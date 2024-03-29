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

With that now merged we can work on adding the functionality and setting up documentation. The two main choices for documentation generation appear to be [rdoc](https://github.com/ruby/rdoc) or [yard](https://yardoc.org/). Yard looks alright, but we're trying to stick to any "official" way of doing something, and with rdoc being put out by ruby, we'll start off with rdoc. We can [`bundle add rdoc --version "~> 6.0" --verbose`](https://bundler.io/man/bundle-add.1.html), but doing this just leads to it permanently hanging on a ""HTTP GET https://index.rubygems.org/versions" immediately after a "HTTP 416 Range Not Satisfiable https://index.rubygems.org/versions". There's quite a few hits for this or similar issues cropping up, but none with a definitive answer or cause, and none that worked to fix the issue here. It took a 20 minute wait for it to finally do anything, then kept asking for my sudo password and refusing to accept it. I retried and it succeeded much quicker, although still took 4 entries of my password to get it to successfully pass and hit that "Bundle complete! 5 Gemfile dependencies, 23 gems now installed". Following the [rdoc](https://github.com/ruby/rdoc) guide to add rdoc to the rakefile leads to a ``rake aborted! NoMethodError: undefined method `delete_if' for nil:NilClass`` which could be connected to [this issue](https://github.com/ruby/rdoc/issues/352), namely ["You haven't told RDoc to document any files"](https://github.com/ruby/rdoc/issues/352#issuecomment-110185993). We can avoid this issue if we use the [rdoc task](https://ruby.github.io/rdoc/RDocTask.html) instead.

As we start to add the first few lines to the main rb file, we've run into yet another rubocop yelling about something inconsequential (Style/NumericLiterals isn't even listed in our rubocop yaml, so we'll have to add it to disable it);
```
lib/collatz.rb:19:20: C: [Correctable] Style/NumericLiterals: Use underscores(_) as thousands separator and separate every 3 digits with them.
VERIFIED_MAXIMUM = 295147905179352825856
                   ^^^^^^^^^^^^^^^^^^^^^
```
We'll also have to add the cop `Naming/MethodParameterName: MinNameLength: 1` to stop it from complaining about all our uses of `"P"`, `"a"`, and `"b"`. Also worth mentioning is that, unlike other implementations, in ruby we can't use a capital letter to start a non-constant value, so we have to swap all capital `"P"` for lowercase `"p"`'s, lest we get the `"Formal argument cannot be a constant"` error. I'm also cautious of `Style/RedundantReturn` -- I'd like to try and stick to the normal ruby style, but it relies on the novel awareness that the last line of a function without an explicit return is returned. I'll have to simply remember that for later. Another cop is complaining about `Lint/AmbiguousOperatorPrecedence: Wrap expressions with varying precedence with parentheses to avoid ambiguity.`, which seems absurd. After fixing some of these, my line `if n%p == 0 then n/p else ((a*n)+b) end` is still generating the following errors;
```
lib/collatz.rb:96:3: C: [Correctable] Style/OneLineConditional: Favor the ternary operator (?:) or multi-line constructs over single-line if/then/else/end constructs.
  if n%p == 0 then n/p else ((a*n)+b) end
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/collatz.rb:96:6: C: [Correctable] Style/NumericPredicate: Use (n%p).zero? instead of n%p == 0.
  if n%p == 0 then n/p else ((a*n)+b) end
     ^^^^^^^^
```
Rubocop is happy if we replace it with `(n%p).zero? ? (n/p) : ((a*n)+b)`, which feels so much less readable, and absurd than anyone would consider that more "readable" than the verbose `if/then/else/end`. Another odd ambiguity is that an error can be raised either with `raise StandardError, 'message'` or `raise StandardError.new('message')` or `raise StandardError.new 'message'`, but the `Style/RaiseArgs` cop has a preference for `raise StandardError, 'message'`. Now we just have to configure the `Metrics/BlockLength` cop which doesn't like all the lines in the spec test. A good suggestion is to set `IgnoredMethods: ['describe', 'context']` according to the docs, which does silence the error, but now returns ``Warning: obsolete parameter `IgnoredMethods` (for `Metrics/BlockLength`) found in .rubocop.yml `IgnoredMethods` has been renamed to `AllowedMethods` and/or `AllowedPatterns`.``. So why are they not mentioned as such on the [rubocop docs](https://docs.rubocop.org/rubocop/cops_metrics.html#metricsblocklength). It feels like a lot of the problems we've run into so far with ruby have been the same as those with go, where it's been historically developed at a pace greater than which it is then adopted, leading to a fragmented ecosystem, although not as badly as it is in go, with solutions to circumvent the at times antithetical expectations easier to find than they were for go. Although a large portion of these issues have been with rubocop. It might be useful, but it adds a lot of noise that needs to be hushed while trying to learn ruby for the first time, even if its suggestions might be temporarily useful. I will say though that setting up the gem deployment was much easier than the maven deployment for java, so all in all it's not too much of a hassle.

The last thing worth mentioning before trying to release 0.1.0 with the function and reverse function, is that there seems to be a bit of a difference in how to provide "kwargs" than in python. In python kwargs are listed as `some_arg_name = some_default_value`, and can then be referenced by name in the function invocation, or supplied positionally, and without specifying a `**kwargs` to splatter additionl inputs, any name supplied that is not specified as an input will cause an error. In ruby, kwargs are listed as `some_arg_name: some_default_value`, and like python, an error will be thrown if a named kwarg is provided on invocation that isn't specified in the function inputs, however it **can only** be supplied to the invocation per its keyword name, it can't be supplied positionally. Meanwhile, "optional" args in ruby that are specified in the function inputs via `some_arg_name = some_default_value` aren't kwargs, but rather positional args that happen to have default values; they can't be supplied to a function invocation by name, only by position, and a quirk of testing how to assign them to learn the difference between ruby and python demonstrates that while specifying `**kwargs` to splatter inputs in python means parameters can be supplied to the invocation by name that weren't specified in the input, attempting to see how "optional args" affect splattering in ruby leads to a false positive of demonstrating something akin to, but not exactly splattering. That is, if some `some_other_arg_name = some_other_value` is supplied to a function invocation in ruby as the input to an "optional arg", this is not splatting the differently named inputs, rather, it is assigning the value to the name as a variable, and providing that value as the input to the positional optional args. So to achieve true "kwargs" in ruby, we need to use `some_arg_name: some_default_value`, and specify them by name in the invocations.

We're now ready to add once again create an empty orphan branch;
1. `git checkout --orphan gh-pages-ruby`
1. `rm .git/index ; git clean -fdx`
1. `git commit -m "Initial empty orphan" --allow-empty`
1. `git push --set-upstream origin gh-pages-ruby`

Well, v0.1.0 has been released, with the function and reverse function. The ruby discord has been very helpful, and has a "Community: code review" channel dedicated for requests for feedback on code samples, so I've asked on there for a review, and gotten some feedback! I want to try and make it more ruby-esque before working on the hailstone and tree graph functions, so that they are made right from the start. The feedback is as thus;
1. It's odd to have all the code in the central `~/collatz.rb` file with a separate `~/collatz/version.rb`, with the suggestion seeming to be to either do away with having a subfolder that contains `example.rb` files that are then included in the main file via `require_relative "collatz/example"`, or move all the contents of the main file into other `*.rb` files that are then required into the main file. The version file was part of what was auto generated by bundler, and I like having the version on its own in its own file, as it makes setting the version file, and reading the version from it in the workflow, much easier.
1. The next piece of feedback, and something I wondered why bundler didn't do from the beginning honestly, is to put _**everything**_ inside a `Collatz` module. I assumed when I first saw that this wasn't done automatically by bundler that the contents of a gem that would then be required into a script would set up the namespace similar to python, and disregarded the fact that it appeared not to do that while setting up the RSpec tests. So moving everything into a top level module to unclobber the "public"`?` namespace.
1. Change `unless p != 0` to `if p.zero?`. I vaguely recall trying something along the lines of inline conditionals when first setting that up, and thought a rubocop had complained about it _not_ being an "unless" clause, but it might have been some other part of the inlining of the conditional, so will definitely try this change, as it certainly is much more readable.
1. In the `reverse_function` rather than do a `pre_values +=`, use the array's `.push` method. Although another user suggest using `<<` instead? It was finally suggested to instead just settle for a multi line if, which isn't _not_ a reasonable suggestion, even if my preference happens to be for flatter lines. It was also made apparent that similar to the `.zero?` function, there is a `.nonzero?` function that can be used instead of the negated assertion of `.zero?`.
1. Instead of setting methods to private with `private :stopping_time_terminus` following the method declaration, simply add `private` before the def (e.g. `private def stopping_time_terminus`). A few sites indicated the same concern another user noted that doing so would make all the methods declared after it also private, however this concern was dissuaded with the assurance that it would not behave that way, instead asserting that the `def something` would return a `Symbol`, which would make `private def something` the same as subsequently passing the symbol of the method to the private modifier.
1. The abuse of `NotImplementedError`, which is meant to be ruby internal only, was mentioned. I was aware of this ahead of time, and probably could have done without adding the function headers before implementing them.
1. On the `KNOWN_CYCLES`, rather than apply the `.freeze` to all elements in the list individually, set `.each(&:freeze).freeze` on the final outer closing bracket `]` of the whole list.

I've fixed most of the above, although some aren't operable at the moment. Setting methods private via `private def method_name` instead of `private :method_name` after the method declaration is causing rubocop to break. I'll get an error message `An error occurred while Style/AccessModifierDeclarations cop was inspecting /mnt/c/Workspaces/GitHub_Skenvy/Collatz/ruby/lib/collatz.rb:71:0.` for both lines, which is then followed by this stack trace.
```
uninitialized constant RuboCop::Version::Server
Did you mean?  TCPServer
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/version.rb:22:in `version'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/cli/command/execute_runner.rb:82:in `display_error_summary'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/cli/command/execute_runner.rb:58:in `display_summary'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/cli/command/execute_runner.rb:27:in `block in execute_runner'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/cli/command/execute_runner.rb:52:in `with_redirect'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/cli/command/execute_runner.rb:25:in `execute_runner'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/cli/command/execute_runner.rb:17:in `run'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/cli/command.rb:11:in `run'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/cli/environment.rb:18:in `run'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/cli.rb:72:in `run_command'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/cli.rb:79:in `execute_runners'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/cli.rb:48:in `run'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/rake_task.rb:51:in `run_cli'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/rake_task.rb:26:in `block (2 levels) in initialize'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/file_utils_ext.rb:58:in `verbose'
/var/lib/gems/2.7.0/gems/rubocop-1.36.0/lib/rubocop/rake_task.rb:24:in `block in initialize'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/task.rb:281:in `block in execute'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/task.rb:281:in `each'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/task.rb:281:in `execute'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/task.rb:219:in `block in invoke_with_call_chain'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/task.rb:199:in `synchronize'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/task.rb:199:in `invoke_with_call_chain'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/task.rb:188:in `invoke'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/application.rb:160:in `invoke_task'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/application.rb:116:in `block (2 levels) in top_level'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/application.rb:116:in `each'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/application.rb:116:in `block in top_level'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/application.rb:125:in `run_with_threads'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/application.rb:110:in `top_level'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/application.rb:83:in `block in run'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/application.rb:186:in `standard_exception_handling'
/var/lib/gems/2.7.0/gems/rake-13.0.6/lib/rake/application.rb:80:in `run'
/var/lib/gems/2.7.0/gems/rake-13.0.6/exe/rake:27:in `<top (required)>'
/usr/local/bin/rake:23:in `load'
/usr/local/bin/rake:23:in `<main>'
RuboCop failed!
```
It appears though that this error may have already had a bug raised and fixed at [rubocop/issues/10994](https://github.com/rubocop/rubocop/issues/10994). It appears in the meantime however that the `Style/AccessModifierDeclarations` cop isn't working as intended. Setting the below does not cause it to error on the `private :method_name` after the method declaration, which is what `AllowModifiersOnSymbols: false` is supposed to disallow.
```yaml
Style/AccessModifierDeclarations:
  EnforcedStyle: inline
  AllowModifiersOnSymbols: false
```
Even though it is not causing it to throw a cop error on the modifier on symbol pattern `private :method_name`, having the above config _is_ preventing it from throwing the hard error above `uninitialized constant RuboCop::Version::Server` that stopped the whole rubocop process, and indeed it passes with `no offenses detected`.
