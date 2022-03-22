# Devlog
The aim is to package as close to as the same functionality as possible across a range of languages, both as a way to be authoritative about "collatz packages" and as a learning opportunity in several languages I have not worked in before, and to serve as a future example for packaging in multiple languages.
## Devlogs
* [go](https://github.com/Skenvy/Collatz/blob/main/go/devlog.md)
* [java](https://github.com/Skenvy/Collatz/blob/main/java/devlog.md)
* [javascript](https://github.com/Skenvy/Collatz/blob/main/javascript/devlog.md)
* [julia](https://github.com/Skenvy/Collatz/blob/main/julia/devlog.md)
* [LaTeX](https://github.com/Skenvy/Collatz/blob/main/LaTeX/devlog.md)
* [python](https://github.com/Skenvy/Collatz/blob/main/python/devlog.md)
* [R](https://github.com/Skenvy/Collatz/blob/main/R/devlog.md)
## Motivation
I've always appreciated the "Rosetta Stone"-esque compilations of similar tasks across multiple languages, including but not limited to;
* [Rosetta Code](http://www.rosettacode.org/wiki/Rosetta_Code)
* [The OG "Hello World" Collection](http://helloworldcollection.de/)
* [Wikipedia's "Hello World" collection](https://en.wikipedia.org/wiki/%22Hello,_World!%22_program)
* [leachim6's "Hello World" compilation](https://github.com/leachim6/hello-world)

And would like to compile a similarly motivated collection of _implementations of functions utilised to compute iterations of the function that comprises the Collatz conjecture_, a number theory conjecture that is incredibly easy to state, but remains unsolved. I've chosen this as the theme as I originally became interested in the problem a few years ago, as a "novel" problem the infamy of which made alluring, and ended up reacquiring some of the key results from a few decades ago.

I would also however, like to focus on languages that can be easily, or consequentially, distributed, and implement not just the algorithm similar to what the linked compilations above do, but also implement the distribution.

I've chosen python to start with as it's very easy to script calculations with, and was the language I wrote some scripts in years ago when playing around with the concept of attacking the Collatz conjecture via repeatedly splitting modulo conjugacy classes and comparing the resulting sub-classes with the set of conjugacy classes that where split. I've also added R and Julia as intended languages to implement next, with their relevance to math/data making them obvious candidates. Go, Java, and JavaScript via Node, all seem like good candidates for the purposes of highly distributable/packageable languages.
