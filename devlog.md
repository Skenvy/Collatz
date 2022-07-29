# Devlog
The aim is to package as close to as the same functionality as possible across a range of languages, both as a way to be authoritative about "collatz packages" and as a learning opportunity in several languages I have not worked in before, and to serve as a future example for packaging in multiple languages.
## Devlogs
* [C#](https://github.com/Skenvy/Collatz/blob/main/C#/devlog.md)
* [Go](https://github.com/Skenvy/Collatz/blob/main/go/devlog.md)
* [Java](https://github.com/Skenvy/Collatz/blob/main/java/devlog.md)
* [Julia](https://github.com/Skenvy/Collatz/blob/main/julia/devlog.md)
* [LaTeX](https://github.com/Skenvy/Collatz/blob/main/LaTeX/devlog.md)
* [Node.JS](https://github.com/Skenvy/Collatz/blob/main/node.js/devlog.md)
* [Python](https://github.com/Skenvy/Collatz/blob/main/python/devlog.md)
* [R](https://github.com/Skenvy/Collatz/blob/main/R/devlog.md)
* [Ruby](https://github.com/Skenvy/Collatz/blob/main/ruby/devlog.md)
## Motivation
I've always appreciated the "Rosetta Stone"-esque compilations of similar tasks across multiple languages, including but not limited to;
* [Rosetta Code](http://www.rosettacode.org/wiki/Rosetta_Code)
* [The OG "Hello World" Collection](http://helloworldcollection.de/)
* [Wikipedia's "Hello World" collection](https://en.wikipedia.org/wiki/%22Hello,_World!%22_program)
* [leachim6's "Hello World" compilation](https://github.com/leachim6/hello-world)

And would like to compile a similarly motivated collection of _implementations of functions utilised to compute iterations of the function that comprises the Collatz conjecture_, a number theory conjecture that is incredibly easy to state, but remains unsolved. I've chosen this as the theme as I originally became interested in the problem a few years ago, as a "novel" problem the infamy of which made alluring, and ended up reacquiring some of the key results from a few decades ago.

I would also however, like to focus on languages that can be easily, or consequentially, distributed, and implement not just the algorithm similar to what the linked compilations above do, but also implement the distribution.

I've chosen python to start with as it's very easy to script calculations with, and was the language I wrote some scripts in years ago when playing around with the concept of attacking the Collatz conjecture via repeatedly splitting modulo conjugacy classes and comparing the resulting sub-classes with the set of conjugacy classes that where split. I've also added R and Julia as intended languages to implement next, with their relevance to math/data making them obvious candidates. Go, Java, and JavaScript via NodeJS, all seem like good candidates for the purposes of highly distributable/packageable languages.

Also worth targetting are the "GitHub packages" which supports Docker/OCI containers, Java Maven, C#/++ nuget, ruby gems, and npm.

Recently, I've been made aware of [https://deps.dev/], and it seems the implementations done so far for [python](https://deps.dev/pypi/collatz), [Java](https://deps.dev/maven/io.github.skenvy%3Acollatz), and [Go](https://deps.dev/go/github.com%2Fskenvy%2Fcollatz%2Fgo) are scoring low! The go package appears to have no score at all, because the go package site does not appear to allow tags to be provided to it in any way other than through tags on the repository that follow semver strict enough to not accept prefixes, as well as any suffix being considered a candidate, and not an actual release, so until I change how I'm tagging orthogonal releases, what's interesting is that the python and java score cards are the same, because it appears to not be scanning them on a per language basis but rather the "meta" health of the repository itself, which is, obviously for both of them, this one, that they and all the others will eventually share. For the health of the repository to get only `3.7/10` is a bit shocking, so it'll be worthwhile reading through the sorts of checks it does, and how to improve on whatever is seems must not be as good as it could be!

[These are the checks it's doing](https://github.com/ossf/scorecard/blob/main/docs/checks.md). Which come from the [Open Source Security Foundation's Scorecard](https://github.com/ossf/scorecard). This is what the score is at the moment.
* `Vulnerabilities`, `License`, `Binary Artifacts`, `Dangerous Workflow`: are all `10/10`.
* `Pinned-Dependencies` is `7/10` for "dependency not pinned by hash detected".
    * There's too many errors to fit on the screen, but it wants every dependency pinned to a hash, semver versions mustn't be good enough for it.
* `Branch-Protection` is `3/10` for "branch protection is not maximal on development and all release branches".
    * Warn: no status checks found to merge onto branch 'main'
    * Warn: number of required reviewers is only 0 on branch 'main'
* `Code-Review` is `0/10` for having only 2 of the last 30 commits against main come in via PR.
* `Maintained` is `0/10` for 1 commit out of 30 and 0 issue activity out of 0 found in the last 90 days.
* `CII-Best-Practices` is `0/10` for not having [this badge](https://bestpractices.coreinfrastructure.org/en)?
    * Add the badge and work on its goals.
* `Dependency-Update-Tool` is `0/10` for "no update tool detected".
    * Add a dependabot and renovatebot config.
* `Token-Permissions` is `0/10` for "non read-only tokens detected in GitHub workflows".
    * Define a "topLevel permission" in every workflow.
* `Signed-Releases` is `0/10` for "0 out of 5 artifacts are signed". It's counting all the python release files.
* `Security-Policy` is `0/10` for "security policy file not detected".
    * Add a [`SECURITY.md`](https://docs.github.com/en/code-security/getting-started/adding-a-security-policy-to-your-repository)
* `Fuzzing` is `0/10` for "project is not fuzzed".
    * Use either [OSS-Fuzz](https://google.github.io/oss-fuzz/) or [ClusterFuzzLite](https://google.github.io/clusterfuzzlite/).
